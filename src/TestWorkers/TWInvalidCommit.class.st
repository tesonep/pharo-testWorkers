Class {
	#name : #TWInvalidCommit,
	#superclass : #TWCommit,
	#category : #'TestWorkers-Changes'
}

{ #category : #testing }
TWInvalidCommit >> canStartTransaction [
	
	^ true
]

{ #category : #testing }
TWInvalidCommit >> isInvalid [ 
	
	^ true
]

{ #category : #operations }
TWInvalidCommit >> startTransaction [

	| newCommit |
	newCommit := TWMemoryCommit new.
	newCommit parentCommit: self.
	
	repository currentCommit: newCommit
]
