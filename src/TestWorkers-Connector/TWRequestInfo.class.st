Class {
	#name : #TWRequestInfo,
	#superclass : #TWMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #private }
TWRequestInfo >> addAdditionalHeaders: frame [

	super addAdditionalHeaders: frame.
	frame headerAt: 'reply-to' put: '/temp-queue/client-queue'
]

{ #category : #sending }
TWRequestInfo >> execute: client [

	^ client informationRequested: self.
]

{ #category : #sending }
TWRequestInfo >> replyQueue [

	^ messageFrame headerAt: 'reply-to'
]
