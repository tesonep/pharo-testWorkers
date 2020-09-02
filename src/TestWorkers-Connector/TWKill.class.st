Class {
	#name : #TWKill,
	#superclass : #TWWatchdogMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWKill >> execute: aClient [

	aClient shutdown.
]

{ #category : #sending }
TWKill >> queueName [

	^ self workerExchange
]
