Class {
	#name : #TWPong,
	#superclass : #TWMessage,
	#instVars : [
		'path'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #sending }
TWPong >> execute: client [

	('Pong:' , path) traceCr.
]

{ #category : #sending }
TWPong >> initialize [
	
	super initialize.
	path := FileLocator workingDirectory resolve fullName
]

{ #category : #sending }
TWPong >> queueName [

	^ 'watchdog'
]
