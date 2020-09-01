Class {
	#name : #TWMaterializedInstance,
	#superclass : #TWWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWMaterializedInstance >> ensureRunning [ 

	instance doStart
]

{ #category : #accessing }
TWMaterializedInstance >> stateName [

	^ 'Materialized'
]
