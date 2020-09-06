Class {
	#name : #TWAbstractMethodModification,
	#superclass : #TWAbstractChange,
	#instVars : [
		'protocol'
	],
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #applying }
TWAbstractMethodModification >> apply [
	
	| aClass |
	aClass := self class environment classNamed: self className.
	aClass compile: self sourceCode classified: self protocol.
]

{ #category : #accessing }
TWAbstractMethodModification >> protocol [
	^ protocol
]

{ #category : #accessing }
TWAbstractMethodModification >> sourceCode [

	^ definition
]
