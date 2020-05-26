Class {
	#name : #TWMemoryCommit,
	#superclass : #TWCommit,
	#instVars : [
		'changes'
	],
	#category : #'TestWorkers-Changes'
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

{ #category : #initialization }
TWMemoryCommit >> initialize [ 
	
	super initialize.
	changes := OrderedCollection new
]

{ #category : #operations }
TWMemoryCommit >> startTransaction [
	
	TWImpossibleToStartTransaction signal
]
