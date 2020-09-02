Class {
	#name : #TWPong,
	#superclass : #TWWatchdogMessage,
	#instVars : [
		'instanceId',
		'path',
		'pid'
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
