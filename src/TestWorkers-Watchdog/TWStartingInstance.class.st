Class {
	#name : #TWStartingInstance,
	#superclass : #TWManagedWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

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
