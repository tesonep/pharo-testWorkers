Class {
	#name : #TWPong,
	#superclass : #TWWatchdogMessage,
	#instVars : [
		'instanceId',
		'path',
		'pid',
		'host',
		'testId'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #private }
TWPong >> addAdditionalHeaders: frame [

	super addAdditionalHeaders: frame.
	frame headerAt: 'reply-to' put: '/temp-queue/worker-instance'
]

{ #category : #sending }
TWPong >> execute: client [

	client receivePong: self.

]

{ #category : #accessing }
TWPong >> host [
	^ host
]

{ #category : #accessing }
TWPong >> host: anObject [
	host := anObject
]

{ #category : #sending }
TWPong >> initialize [
	
	super initialize.
	
	path := FileLocator workingDirectory resolve fullName.
	host := NetNameResolver localHostName
]

{ #category : #accessing }
TWPong >> instanceId [
	^ instanceId
]

{ #category : #accessing }
TWPong >> instanceId: anObject [
	instanceId := anObject
]

{ #category : #accessing }
TWPong >> path [ 

	^ path
]

{ #category : #accessing }
TWPong >> pid [
	
	^ pid
]

{ #category : #sending }
TWPong >> queueName [

	^ self watchdogQueue
]

{ #category : #sending }
TWPong >> replyQueue [

	^ messageFrame headerAt: 'reply-to'
]

{ #category : #accessing }
TWPong >> testId [

	^ testId
]

{ #category : #accessing }
TWPong >> testId: anObject [

	testId := anObject
]
