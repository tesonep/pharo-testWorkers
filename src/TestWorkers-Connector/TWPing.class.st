Class {
	#name : #TWPing,
	#superclass : #TWWatchdogMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWPing >> execute: client [

	^ client executePing
]

{ #category : #sending }
TWPing >> queueName [

	^ self workerExchange
]
