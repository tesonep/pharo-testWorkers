Class {
	#name : #TWWatchdog,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'rootDirectory',
		'instances',
		'pingService',
		'creationStrategy',
		'onChangeBlock'
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

	| server |

	server := RQServer new
		host: self serverHost;
		username: self username;
		password: self password;
		yourself.
		
	self ensureExchangeOn: server.

]

{ #category : #'private-instances-control' }
TWWatchdog >> ensureTemplate [

	self hasTemplate 
		ifFalse: [ creationStrategy createTemplate ]
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
				directory: self rootDirectory / anIndex asString
				on: self ] 
		as: OrderedCollection
]

{ #category : #events }
TWWatchdog >> onChange: aBlock [

	onChangeBlock := aBlock
]

{ #category : #configuration }
TWWatchdog >> processName [ 

	^ 'TWWatchdog'
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

{ #category : #operations }
TWWatchdog >> sendPing [
	
	TWPing new
		sendOn: connection.
	
	instances do: [:e | e heartbeat ].
	
	onChangeBlock ifNotNil: onChangeBlock
]

{ #category : #operations }
TWWatchdog >> start [

	self ensureQueues.
	
	super start.
	
	pingService := TKTParameterizableService new.
	pingService name: 'TWPingService'.
	pingService stepDelay: 1 second.
	pingService step: [ self sendPing ].
	pingService start.

]

{ #category : #operations }
TWWatchdog >> startInstance: aTWWorkerInstance [ 

	self ensureTemplate.
	aTWWorkerInstance ensureRunning	
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

	pingService 
		ifNotNil: [ pingService stop ].
	
	super stop.
	
		

]

{ #category : #operations }
TWWatchdog >> stopInstance: aWorkerInstance [

	TWKill new sendOn: connection to: aWorkerInstance directQueue
]

{ #category : #operations }
TWWatchdog >> stopInstances [

	TWKill new sendOn: connection.

	
		

]

{ #category : #accessing }
TWWatchdog >> templateName [ 

	^ creationStrategy templateName
]

{ #category : #accessing }
TWWatchdog >> templatePath [ 

	^ rootDirectory / 'template'
]

{ #category : #initialization }
TWWatchdog >> useCreationStrategy: aClass [

	creationStrategy := aClass new
		                    watchdog: self;
		                    yourself
]
