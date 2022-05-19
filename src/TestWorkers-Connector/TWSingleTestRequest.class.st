Class {
	#name : #TWSingleTestRequest,
	#superclass : #TWClassTestRequest,
	#instVars : [
		'testSelector'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWSingleTestRequest >> testSelector [

	^ testSelector
]

{ #category : #accessing }
TWSingleTestRequest >> testSelector: anObject [

	testSelector := anObject
]
