Class {
	#name : #TWKill,
	#superclass : #TWMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWKill >> execute: aClient [

	aClient shutdown.
]

{ #category : #sending }
TWKill >> queueName [

	^ '/exchange/workers'
]
