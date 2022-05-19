Class {
	#name : #TWTestResponse,
	#superclass : #TWMessage,
	#instVars : [
		'testResults',
		'testRequest'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #sending }
TWTestResponse >> execute: client [

	client runTestResponse: self
]

{ #category : #sending }
TWTestResponse >> handleSendError: anError on: connection [

	TWTestExecutionError new
		testRequest: testRequest;
		exceptionMessage: anError class name printString , anError messageText printString;
		serializedException: (self tryToSerialize: anError);
		uuid: self uuid;
		sendOn: connection
		
]

{ #category : #sending }
TWTestResponse >> queueName [

	^ 'testResponse'
	
]

{ #category : #accessing }
TWTestResponse >> testRequest [
	^ testRequest
]

{ #category : #accessing }
TWTestResponse >> testRequest: anObject [
	testRequest := anObject
]

{ #category : #accessing }
TWTestResponse >> testResults [

	^ testResults
]

{ #category : #accessing }
TWTestResponse >> testResults: aTestResult [ 
	testResults := aTestResult
]

{ #category : #sending }
TWTestResponse >> tryToSerialize: anError [

	[ ^ FLSerializer serializeToByteArray: anError  ] 
		onErrorDo: [ ^ nil ].
]
