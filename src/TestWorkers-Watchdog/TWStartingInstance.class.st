Class {
	#name : #TWStartingInstance,
	#superclass : #TWManagedWorkerInstanceState,
	#instVars : [
		'startTime'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #operations }
TWStartingInstance >> checkState [

	(startTime + 60 seconds < DateAndTime now)
		ifTrue: [ 
			instance state: (TWMaterializedInstance on: instance).
			instance state checkState ]
	
]

{ #category : #operations }
TWStartingInstance >> heartbeat [ 

	self checkState 
]

{ #category : #initialization }
TWStartingInstance >> initialize [

	super initialize.
	startTime := DateAndTime now
]

{ #category : #operations }
TWStartingInstance >> pongReceived: aTWPong [ 
			
	aTWPong path = instance path fullName
		ifFalse: [ ^ self ].
	
	(instance hasAlreadyRegistredToWatchdogWithId: aTWPong instanceId) ifTrue: [  ^self ].
	
	instance instanceId: aTWPong instanceId.
	instance pid: aTWPong pid.
	instance host: aTWPong host.
	instance directQueue: aTWPong replyQueue.
	
	instance state: (TWRunningInstance on: instance).
]

{ #category : #accessing }
TWStartingInstance >> stateName [

	^ 'Starting'
]
