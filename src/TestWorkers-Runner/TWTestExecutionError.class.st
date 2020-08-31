Class {
	#name : #TWTestExecutionError,
	#superclass : #TWMessage,
	#instVars : [
		'testClassName',
		'exceptionMessage',
		'serializedException'
	],
	#category : #'TestWorkers-Runner'
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
TWTestExecutionError >> testClassName [
	^ testClassName
]

{ #category : #accessing }
TWTestExecutionError >> testClassName: anObject [
	testClassName := anObject
]
