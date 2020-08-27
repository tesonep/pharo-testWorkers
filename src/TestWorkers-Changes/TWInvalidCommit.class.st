Class {
	#name : #TWInvalidCommit,
	#superclass : #TWCommit,
	#category : #'TestWorkers-Changes-Commits'
}

{ #category : #testing }
TWInvalidCommit >> canStartTransaction [
	
	^ false
]

{ #category : #testing }
TWInvalidCommit >> isInvalid [ 
	
	^ true
]

{ #category : #operations }
TWInvalidCommit >> startTransaction [

	TWImpossibleToStartTransaction signal
]
