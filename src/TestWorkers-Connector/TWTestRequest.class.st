Class {
	#name : #TWTestRequest,
	#superclass : #TWMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #converting }
TWTestRequest >> execute: client [

	client runTestMessage: self
]

{ #category : #testing }
TWTestRequest >> executionResponseFor: testResults [

	^ TWTestResponse new
		  testResults: testResults;
		  testRequest: self;
		  uuid: self uuid;
		  yourself
]

{ #category : #accessing }
TWTestRequest >> hasException [
	
	^ false
]

{ #category : #converting }
TWTestRequest >> queueName [

	^ 'testRequest'

]
