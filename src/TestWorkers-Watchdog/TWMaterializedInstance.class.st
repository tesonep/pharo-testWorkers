Class {
	#name : #TWMaterializedInstance,
	#superclass : #TWManagedWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWMaterializedInstance >> ensureRunning [ 

	instance doStart
]

{ #category : #operations }
TWMaterializedInstance >> heartbeat [ 

	(instance path exists and: [ instance imagePath exists ])
			ifFalse: [ 	instance state: (TWNonExistingInstance on: instance).
							instance state checkState. ]
]

{ #category : #operations }
TWMaterializedInstance >> pongReceived: aTWPong [ 
			
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
TWMaterializedInstance >> stateName [

	^ 'Materialized'
]
