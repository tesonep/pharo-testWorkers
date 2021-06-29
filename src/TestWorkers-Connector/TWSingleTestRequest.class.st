Class {
	#name : #TWSingleTestRequest,
	#superclass : #TWTestRequest,
	#instVars : [
		'testSelector'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #testing }
TWSingleTestRequest >> executionResponseFor: testResults [

	^ TWSingleTestResponse new
		  testResults: testResults;
		  testClassName: self testClassName;
		  testSelector: self testSelector;
		  uuid: self uuid;
		  yourself
]

{ #category : #accessing }
TWSingleTestRequest >> testSelector [

	^ testSelector
]

{ #category : #accessing }
TWSingleTestRequest >> testSelector: anObject [

	testSelector := anObject
]
