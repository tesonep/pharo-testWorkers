Class {
	#name : #TWInitialCommit,
	#superclass : #TWCommit,
	#instVars : [
		'imageVersion'
	],
	#category : #'TestWorkers-Changes'
}

{ #category : #testing }
TWInitialCommit >> canStartTransaction [

	^ true
]

{ #category : #accessing }
TWInitialCommit >> imageVersion [
	
	^ imageVersion
]

{ #category : #operations }
TWInitialCommit >> initialize [

	super initialize.
	commitId := UUID new.
	imageVersion := SystemVersion current
]

{ #category : #operations }
TWInitialCommit >> startTransaction [

	| newCommit |
	newCommit := TWMemoryCommit new.
	newCommit parentCommit: self.
	newCommit repository: repository.
	
	repository currentCommit: newCommit
]
