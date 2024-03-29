Class {
	#name : #TWWatchdog,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'rootDirectory',
		'instances',
		'creationStrategy',
		'headless',
		'idleSince'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'as yet unclassified' }
TWWatchdog class >> openExample [

	<script>

	| watchdog |
	watchdog := self new
		            rootDirectory:
			            '/Users/admin/dev/Pharo/lifeware/secondPass/workers/runners'
				            asFileReference;
		            useCreationStrategy: TWLatestPharoCreationStrategy;
		            numberOfInstances: 8;
		            yourself.

	watchdog start.

	(TWWatchdogPresenter on: watchdog) 
		openWithSpec.
		
	^ watchdog
]

{ #category : #private }
TWWatchdog >> areAllInstancesIdle [
	^instances allSatisfy: [:anInstance | anInstance state test isNil ]
]

{ #category : #'private-instances-control' }
TWWatchdog >> createInstance: anId [ 

	| directory |

	directory := rootDirectory / anId asString.
	directory ensureCreateDirectory.
	self templatePath copyAllTo: directory.
]

{ #category : #private }
TWWatchdog >> ensureExchangeOn: server [

	server exchanges 
		detect: [ :anExchange | anExchange name = TWWatchdogMessage workerExchangeName ]
		ifFound: [ ^ self ]
		ifNone: [ 
			| newExchange |
			
			newExchange := RQExchange new.
			newExchange 
				server: server;
				vhost: '/';
				name: 	TWWatchdogMessage workerExchangeName;
				type: 'fanout';
				save ].
]

{ #category : #private }
TWWatchdog >> ensureQueues [
		
	self ensureExchangeOn: self rqServer.

]

{ #category : #'private-instances-control' }
TWWatchdog >> ensureTemplate [

	self hasTemplate 
		ifFalse: [ creationStrategy createTemplate ]
]

{ #category : #testing }
TWWatchdog >> hasAnInstanceRegistredWithId: anId [

	^ instances anySatisfy: [ :instance | instance instanceId = anId ]
]

{ #category : #testing }
TWWatchdog >> hasTemplate [

	^ (self templatePath / self templateName ) exists 
		
]

{ #category : #initialization }
TWWatchdog >> initialize [

	super initialize.
	instances := OrderedCollection new.

]

{ #category : #configuration }
TWWatchdog >> inputQueueName [ 

	^ TWWatchdogMessage watchdogQueue
]

{ #category : #accessing }
TWWatchdog >> instances [
	^ instances
]

{ #category : #operations }
TWWatchdog >> killed: aTWKilled [ 
	
	instances do: [ :anInstance | anInstance killed: aTWKilled ]
]

{ #category : #'private-instances-control' }
TWWatchdog >> launchInstances [
	
	instances do: [ :anInstance | anInstance ensureRunning ]
]

{ #category : #'instances-control' }
TWWatchdog >> materializeInstances [
	
	instances do: [ :anInstance | 
		anInstance ensureMaterialized ]
]

{ #category : #'instances-control' }
TWWatchdog >> numberOfInstances: anInteger [

	instances := (1 to: anInteger)
		             collect: [ :anIndex | 
			             TWManagedWorkerInstance
				             directory: (creationStrategy
						              instanceDirectorWithRoot: self rootDirectory
						              andImageIndex: anIndex)
				             on: self
				             headless: self headless ]
		             as: OrderedCollection
]

{ #category : #configuration }
TWWatchdog >> processName [ 

	^ 'TWWatchdog'
]

{ #category : #operations }
TWWatchdog >> processRequest [ 

	super processRequest.
	instances do: [ :e | e heartbeat ].
	self testForIdle
]

{ #category : #operations }
TWWatchdog >> receivePong: aTWPong [

	instances do: [ :anInstance | anInstance pongReceived: aTWPong ]
]

{ #category : #accessing }
TWWatchdog >> rootDirectory [
	^ rootDirectory
]

{ #category : #accessing }
TWWatchdog >> rootDirectory: anObject [
	rootDirectory := anObject
]

{ #category : #accessing }
TWWatchdog >> headless [
	^ headless ifNil: [true]
]

{ #category : #accessing }
TWWatchdog >> headless: anObject [
	headless := anObject
]

{ #category : #operations }
TWWatchdog >> start [

	self ensureQueues.
	
	super start.
]

{ #category : #operations }
TWWatchdog >> startInstance: aTWWorkerInstance [ 

	[self ensureTemplate.
	aTWWorkerInstance ensureRunning	] on: Abort do: [  ]
]

{ #category : #operations }
TWWatchdog >> startInstances [

	[self ensureTemplate.
	self launchInstances ] on: Abort do: [  ]
]

{ #category : #operations }
TWWatchdog >> stop [ 

	[self stopInstances] onErrorDo: [].
	
	5 seconds wait.
	
	super stop.
	
		

]

{ #category : #operations }
TWWatchdog >> stopInstance: aWorkerInstance [

	TWKill new sendOn: connection to: aWorkerInstance directQueue
]

{ #category : #operations }
TWWatchdog >> stopInstances [

	TWKill new sendOn: connection.
	instances do: [ :e | e heartbeat ].

	
		

]

{ #category : #accessing }
TWWatchdog >> templateName [ 

	^ creationStrategy templateName
]

{ #category : #accessing }
TWWatchdog >> templatePath [ 

	^ rootDirectory / creationStrategy templateFolderName
]

{ #category : #'instances-control' }
TWWatchdog >> testForIdle [

	self areAllInstancesIdle ifFalse: [ idleSince := DateAndTime now ].
	idleSince
		ifNotNil: [ 
			(DateAndTime now - idleSince > 80 seconds)
					ifTrue: [ 
						idleSince := DateAndTime now.
						[ (TWIdle new) sendOn: connection ] onErrorDo: [  ] ] ]
]

{ #category : #initialization }
TWWatchdog >> useCreationStrategy: aClass [

	creationStrategy := aClass new
		                    watchdog: self;
		                    yourself
]
