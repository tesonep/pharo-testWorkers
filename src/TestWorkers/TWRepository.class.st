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

{ #category : #operations }
TWRepository >> commit [
	
	currentCommit commit
]

{ #category : #accessing }
TWRepository >> commits [
	^ commits
]

{ #category : #operations }
TWRepository >> createInitialCommit [

	currentCommit isInvalid ifFalse: [ self error: 'Already we have initial commit' ].
	currentCommit := TWInitialCommit new.
	currentCommit repository: self.
	
	commits removeAll.
	commits add: currentCommit
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
