Class {
	#name : #TWPing,
	#superclass : #TWMessage,
	#category : #'TestWorkers-Runner'
}

{ #category : #sending }
TWPing >> execute: client [

	^ client executePing
]

{ #category : #sending }
TWPing >> queueName [

	^ '/exchange/workers'
]
