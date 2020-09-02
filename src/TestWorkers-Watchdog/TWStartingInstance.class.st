Class {
	#name : #TWStartingInstance,
	#superclass : #TWWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #operations }
TWStartingInstance >> pongReceived: aTWPong [ 
			
	aTWPong path = instance path fullName
		ifFalse: [ ^ self ].
	
	instance instanceId: aTWPong instanceId.
	instance pid: aTWPong pid.
	instance host: aTWPong host.
	
	instance state: (TWRunningInstance on: instance).
]

{ #category : #accessing }
TWStartingInstance >> stateName [

	^ 'Starting'
]
