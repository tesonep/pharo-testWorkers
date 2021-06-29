Class {
	#name : #TWSingleTestResponse,
	#superclass : #TWTestResponse,
	#instVars : [
		'testSelector'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWSingleTestResponse >> testSelector [

	^ testSelector
]

{ #category : #accessing }
TWSingleTestResponse >> testSelector: anObject [

	testSelector := anObject
]
