Class {
	#name : #TWPong,
	#superclass : #TWMessage,
	#instVars : [
		'path'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWPong >> execute: client [

	client receivePong: self
]

{ #category : #sending }
TWPong >> initialize [
	
	super initialize.
	path := FileLocator workingDirectory resolve fullName
]

{ #category : #accessing }
TWPong >> path [ 

	^ path
]

{ #category : #sending }
TWPong >> queueName [

	^ 'watchdog'
]
