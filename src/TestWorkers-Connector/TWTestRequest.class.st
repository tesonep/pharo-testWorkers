Class {
	#name : #TWTestRequest,
	#superclass : #TWMessage,
	#instVars : [
		'testClassName'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #testing }
TWTestRequest >> buildSuite [
	
	^ (self class environment classNamed: testClassName) buildSuite 
]

{ #category : #converting }
TWTestRequest >> execute: client [

	client runTestMessage: self
]

{ #category : #testing }
TWTestRequest >> executionResponseFor: testResults [

	^ TWTestResponse new
		  testResults: testResults;
		  testClassName: self testClassName;
		  uuid: self uuid;
		  yourself
]

{ #category : #accessing }
TWTestRequest >> hasException [
	
	^ false
]

{ #category : #accessing }
TWTestRequest >> name [
	^ testClassName
]

{ #category : #converting }
TWTestRequest >> queueName [

	^ 'testRequest'

]

{ #category : #accessing }
TWTestRequest >> testClassName [
	^ testClassName
]

{ #category : #accessing }
TWTestRequest >> testClassName: anObject [
	testClassName := anObject
]
