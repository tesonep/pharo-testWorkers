Class {
	#name : #TWMemoryCommit,
	#superclass : #TWCommit,
	#instVars : [
		'changes',
		'commitDate'
	],
	#category : #'TestWorkers-Changes-Commits'
}

{ #category : #changes }
TWMemoryCommit >> addChange: aChange [

	changes add: aChange
]

{ #category : #testing }
TWMemoryCommit >> canStartTransaction [

	^ false
]

{ #category : #changes }
TWMemoryCommit >> changes [
	
	^ changes
]

{ #category : #operations }
TWMemoryCommit >> commit [
	
	| newCommit |
	newCommit := TWMemoryCommit new.
	newCommit parentCommit: self.
	newCommit repository: repository.
	commitDate := DateAndTime now.
	
	repository currentCommit: newCommit
]

{ #category : #initialization }
TWMemoryCommit >> initialize [ 
	
	super initialize.
	changes := OrderedCollection new.
	commitId := UUID new
]

{ #category : #changes }
TWMemoryCommit >> lastChange [

	^ changes size = 0 ifTrue: [ nil ] ifFalse: [ changes last ]
]

{ #category : #operations }
TWMemoryCommit >> startTransaction [
	
	TWImpossibleToStartTransaction signal
]
