Class {
	#name : #TWTestExecutionError,
	#superclass : #TWMessage,
	#instVars : [
		'exceptionMessage',
		'serializedException',
		'testRequest'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWTestExecutionError >> exceptionMessage [
	^ exceptionMessage
]

{ #category : #accessing }
TWTestExecutionError >> exceptionMessage: anObject [
	exceptionMessage := anObject
]

{ #category : #sending }
TWTestExecutionError >> execute: client [

	client runTestExecutionError: self
]

{ #category : #testing }
TWTestExecutionError >> hasException [
	
	^ false
]

{ #category : #sending }
TWTestExecutionError >> queueName [

	^ 'testResponse'
	
]

{ #category : #accessing }
TWTestExecutionError >> serializedException [
	^ serializedException
]

{ #category : #accessing }
TWTestExecutionError >> serializedException: anObject [
	serializedException := anObject
]

{ #category : #accessing }
TWTestExecutionError >> testRequest [
	^ testRequest
]

{ #category : #accessing }
TWTestExecutionError >> testRequest: anObject [
	testRequest := anObject
]
