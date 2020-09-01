Class {
	#name : #TWWatchdog,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'rootDirectory',
		'instances',
		'pingService',
		'creationStrategy'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'private-instances-control' }
TWWatchdog >> createInstance: anId [ 

	| directory |

	directory := rootDirectory / anId asString.
	directory ensureCreateDirectory.
	self templatePath copyAllTo: directory.
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
	creationStrategy := TWLatestPharoCreationStrategy new
		watchdog: self;
		yourself.

]

{ #category : #configuration }
TWWatchdog >> inputQueueName [ 

	^ 'watchdog'
]

{ #category : #accessing }
TWWatchdog >> instances [
	^ instances
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
			TWWorkerInstance 
				directory: self rootDirectory / anIndex asString
				on: self ] 
		as: OrderedCollection
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
]

{ #category : #operations }
TWWatchdog >> start [

	super start.
	
	pingService := TKTParameterizableService new.
	pingService name: 'TWPingService'.
	pingService stepDelay: 1 second.
	pingService step: [ self sendPing ].
	pingService start.
	
	self launchInstances 
]

{ #category : #operations }
TWWatchdog >> stop [ 

	TWKill new sendOn: connection.

	pingService 
		ifNotNil: [ pingService stop ].
	
	super stop.
	
		

]

{ #category : #accessing }
TWWatchdog >> templateName [ 

	^ 'worker.image'
]

{ #category : #accessing }
TWWatchdog >> templatePath [ 

	^ rootDirectory / 'template'
]
