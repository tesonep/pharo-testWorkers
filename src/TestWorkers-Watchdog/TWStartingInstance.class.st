Class {
	#name : #TWStartingInstance,
	#superclass : #TWWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #operations }
TWStartingInstance >> pongReceived: aTWPong [ 
	
	instance instanceId: aTWPong instanceId.
	instance pid: aTWPong pid.
	
	instance state: (TWRunningInstance on: instance).
]

{ #category : #accessing }
TWStartingInstance >> stateName [

	^ 'Starting'
]
