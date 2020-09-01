Class {
	#name : #TWWorkerInstanceState,
	#superclass : #Object,
	#instVars : [
		'instance'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'instance creation' }
TWWorkerInstanceState class >> on: anInstance [

	^ self new
		instance: anInstance;
		yourself
]

{ #category : #operations }
TWWorkerInstanceState >> checkState [

	"By default empty"
]

{ #category : #operations }
TWWorkerInstanceState >> ensureMaterialized [
	
	" I do nothing by default"
]

{ #category : #operations }
TWWorkerInstanceState >> ensureRunning [
	
	" I do nothing "
]

{ #category : #operations }
TWWorkerInstanceState >> heartbeat [
	" nothing to do"
]

{ #category : #accessing }
TWWorkerInstanceState >> instance [
	^ instance
]

{ #category : #accessing }
TWWorkerInstanceState >> instance: anObject [
	instance := anObject
]

{ #category : #operations }
TWWorkerInstanceState >> pongReceived: aTWPong [ 

	" I do nothing "
]

{ #category : #printing }
TWWorkerInstanceState >> printOn: anStream [

	anStream nextPutAll: self stateName
]

{ #category : #accessing }
TWWorkerInstanceState >> stateName [

	^ self subclassResponsibility
]
