Class {
	#name : #TWManagedWorkerInstanceState,
	#superclass : #Object,
	#instVars : [
		'instance'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'instance creation' }
TWManagedWorkerInstanceState class >> on: anInstance [

	^ self new
		instance: anInstance;
		yourself
]

{ #category : #operations }
TWManagedWorkerInstanceState >> checkState [

	"By default empty"
]

{ #category : #operations }
TWManagedWorkerInstanceState >> ensureMaterialized [
	
	" I do nothing by default"
]

{ #category : #operations }
TWManagedWorkerInstanceState >> ensureRunning [
	
	" I do nothing "
]

{ #category : #operations }
TWManagedWorkerInstanceState >> heartbeat [
	" nothing to do"
]

{ #category : #accessing }
TWManagedWorkerInstanceState >> instance [
	^ instance
]

{ #category : #accessing }
TWManagedWorkerInstanceState >> instance: anObject [
	instance := anObject
]

{ #category : #operations }
TWManagedWorkerInstanceState >> killed: aTWKilled [ 
	
	" nothing to do"
]

{ #category : #operations }
TWManagedWorkerInstanceState >> lastPong [

	^ nil
]

{ #category : #operations }
TWManagedWorkerInstanceState >> pongReceived: aTWPong [ 

	" I do nothing "
]

{ #category : #printing }
TWManagedWorkerInstanceState >> printOn: anStream [

	anStream nextPutAll: self stateName
]

{ #category : #accessing }
TWManagedWorkerInstanceState >> stateName [

	^ self subclassResponsibility
]

{ #category : #tests }
TWManagedWorkerInstanceState >> testId [

	^ nil
	
]
