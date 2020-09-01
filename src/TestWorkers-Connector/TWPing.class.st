Class {
	#name : #TWPing,
	#superclass : #TWMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWPing >> execute: client [

	^ client executePing
]

{ #category : #sending }
TWPing >> queueName [

	^ '/exchange/workers'
]
