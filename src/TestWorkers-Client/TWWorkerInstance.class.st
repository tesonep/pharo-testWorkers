Class {
	#name : #TWWorkerInstance,
	#superclass : #Object,
	#instVars : [
		'workerInstanceInfo'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'TestWorkers-Client'
}

{ #category : #'instance creation' }
TWWorkerInstance class >> for: aTWInforResponse [

	^ self new
		workerInstanceInfo: aTWInforResponse;
		yourself.
]

{ #category : #accessing }
TWWorkerInstance >> workerInstanceInfo [
	^ workerInstanceInfo
]

{ #category : #accessing }
TWWorkerInstance >> workerInstanceInfo: anObject [
	workerInstanceInfo := anObject
]
