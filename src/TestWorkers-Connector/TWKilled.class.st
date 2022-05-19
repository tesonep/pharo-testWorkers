Class {
	#name : #TWKilled,
	#superclass : #TWWatchdogMessage,
	#instVars : [
		'instanceId',
		'path',
		'pid'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWKilled >> execute: aTWWatchdog [ 
	
	aTWWatchdog killed: self
]

{ #category : #sending }
TWKilled >> initialize [
	
	super initialize.
	path := FileLocator workingDirectory resolve fullName
]

{ #category : #accessing }
TWKilled >> instanceId [
	^ instanceId
]

{ #category : #accessing }
TWKilled >> instanceId: anObject [
	instanceId := anObject
]

{ #category : #accessing }
TWKilled >> path [
	^ path
]

{ #category : #accessing }
TWKilled >> path: anObject [
	path := anObject
]

{ #category : #accessing }
TWKilled >> pid [
	^ pid
]

{ #category : #accessing }
TWKilled >> pid: anObject [
	pid := anObject
]

{ #category : #sending }
TWKilled >> queueName [

	^ self watchdogQueue
]
