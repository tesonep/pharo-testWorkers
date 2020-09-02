Class {
	#name : #TWMaterializedInstance,
	#superclass : #TWWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWMaterializedInstance >> ensureRunning [ 

	instance doStart
]

{ #category : #operations }
TWMaterializedInstance >> pongReceived: aTWPong [ 
			
	aTWPong path = instance path fullName
		ifFalse: [ ^ self ].
	
	instance instanceId: aTWPong instanceId.
	instance pid: aTWPong pid.
	instance host: aTWPong host.
	
	instance state: (TWRunningInstance on: instance).
]

{ #category : #accessing }
TWMaterializedInstance >> stateName [

	^ 'Materialized'
]
