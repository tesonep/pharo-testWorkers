Class {
	#name : #TWPushChanges,
	#superclass : #TWMessage,
	#instVars : [
		'commit'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWPushChanges >> commit [
	^ commit
]

{ #category : #accessing }
TWPushChanges >> commit: anObject [
	commit := anObject
]

{ #category : #sending }
TWPushChanges >> execute: client [

	client receiveCommit: self commit.
]

{ #category : #sending }
TWPushChanges >> queueName [

	^ 'watchdog-' , NetNameResolver localHostName
	
]
