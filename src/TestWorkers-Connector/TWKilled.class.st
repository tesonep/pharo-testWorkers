Class {
	#name : #TWKilled,
	#superclass : #TWMessage,
	#instVars : [
		'instanceId',
		'path',
		'pid'
	],
	#category : #'TestWorkers-Connector'
}

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

	^ 'watchdog'
]
