Class {
	#name : #TWInfoResponse,
	#superclass : #TWMessage,
	#instVars : [
		'instanceId',
		'path',
		'host'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWInfoResponse >> execute: client [

	^ client informationArrived: self
]

{ #category : #accessing }
TWInfoResponse >> host [
	^ host
]

{ #category : #accessing }
TWInfoResponse >> host: anObject [
	host := anObject
]

{ #category : #sending }
TWInfoResponse >> initialize [
	
	super initialize.
	
	path := FileLocator workingDirectory resolve fullName.
	host := NetNameResolver localHostName
]

{ #category : #accessing }
TWInfoResponse >> instanceId [
	^ instanceId
]

{ #category : #accessing }
TWInfoResponse >> instanceId: anObject [
	instanceId := anObject
]

{ #category : #accessing }
TWInfoResponse >> path [
	^ path
]

{ #category : #accessing }
TWInfoResponse >> path: anObject [
	path := anObject
]
