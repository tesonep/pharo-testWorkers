Class {
	#name : #TWMultipleTestRequest,
	#superclass : #TWTestRequest,
	#instVars : [
		'tests'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWMultipleTestRequest >> tests [

	^ tests
]

{ #category : #accessing }
TWMultipleTestRequest >> tests: aCollection [

	tests := aCollection
]
