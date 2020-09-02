Class {
	#name : #TWNonExistingInstance,
	#superclass : #TWWorkerInstanceState,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'states - handling' }
TWNonExistingInstance >> checkState [
	
	"If the path exists and the image exists I change to materialized state."

	(instance path exists and: [ instance imagePath exists ])
		ifTrue: [ instance state: (TWMaterializedInstance on: instance) ]
	
]

{ #category : #operations }
TWNonExistingInstance >> ensureMaterialized [
	
	instance materialize.
]

{ #category : #operations }
TWNonExistingInstance >> ensureRunning [
	
	instance materialize.
	instance ensureRunning.
]

{ #category : #accessing }
TWNonExistingInstance >> stateName [

	^ 'Not Materialized'
]
