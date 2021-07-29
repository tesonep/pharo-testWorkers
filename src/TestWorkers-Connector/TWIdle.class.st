Class {
	#name : #TWIdle,
	#superclass : #TWWatchdogMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWIdle >> execute: aClient [

	aClient idleWatchdog.
]

{ #category : #sending }
TWIdle >> queueName [

	^ 'testResponse'
	
]
