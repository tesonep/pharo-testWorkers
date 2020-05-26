Class {
	#name : #TWCommit,
	#superclass : #Object,
	#instVars : [
		'parentCommit',
		'repository'
	],
	#category : #'TestWorkers-Changes'
}

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
