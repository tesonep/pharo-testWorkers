Class {
	#name : #TWRepository,
	#superclass : #Object,
	#instVars : [
		'changeCollector',
		'commits',
		'currentCommit'
	],
	#category : #'TestWorkers-Changes'
}

{ #category : #actions }
TWRepository >> close [

	changeCollector unregister
]

{ #category : #accessing }
TWRepository >> currentCommit [
	^ currentCommit
]

{ #category : #accessing }
TWRepository >> currentCommit: aCommit [ 
	
	currentCommit := aCommit.
	commits add: aCommit.
]

{ #category : #initialization }
TWRepository >> initialize [

	super initialize.
	
	commits := Set new.
	changeCollector := TWChangeCollector new.
	changeCollector repository: self.
	
	self currentCommit: (TWInvalidCommit new
		repository: self;
		yourself)
	
]

{ #category : #actions }
TWRepository >> startTransaction [

	currentCommit startTransaction.
	changeCollector ensureRegistered.
]
