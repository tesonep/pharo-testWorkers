Class {
	#name : #TWCommit,
	#superclass : #Object,
	#instVars : [
		'parentCommit',
		'repository',
		'commitId'
	],
	#category : #'TestWorkers-Changes-Commits'
}

{ #category : #changes }
TWCommit >> allChanges [

	| parentChanges |
	
	parentChanges := parentCommit ifNil: [ #() ] ifNotNil: [ parentCommit allChanges ].
	^ parentChanges , self changes
]

{ #category : #accessing }
TWCommit >> commitId [
	
	^ commitId
]

{ #category : #testing }
TWCommit >> isInvalid [ 

	^ false
]

{ #category : #accessing }
TWCommit >> parentCommit [
	^ parentCommit
]

{ #category : #accessing }
TWCommit >> parentCommit: anObject [
	parentCommit := anObject
]

{ #category : #accessing }
TWCommit >> repository [
	^ repository
]

{ #category : #accessing }
TWCommit >> repository: anObject [
	repository := anObject
]
