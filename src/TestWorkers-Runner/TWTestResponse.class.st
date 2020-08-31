Class {
	#name : #TWTestResponse,
	#superclass : #TWMessage,
	#instVars : [
		'testResults'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #sending }
TWTestResponse >> execute: client [

	client runTestResponse: self
]

{ #category : #sending }
TWTestResponse >> queueName [

	^ 'testResponse'
	
]

{ #category : #accessing }
TWTestResponse >> testResults [

	^ testResults
]

{ #category : #accessing }
TWTestResponse >> testResults: aTestResult [ 
	testResults := aTestResult
]
