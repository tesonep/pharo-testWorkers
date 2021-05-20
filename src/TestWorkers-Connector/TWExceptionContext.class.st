Class {
	#name : #TWExceptionContext,
	#superclass : #Object,
	#instVars : [
		'methodClassName',
		'receiverClassName',
		'methodSelector',
		'instructionPointer',
		'sender'
	],
	#category : #'TestWorkers-Connector-Results'
}

{ #category : #accessing }
TWExceptionContext >> compiledMethod [
	
	^ (self class environment classNamed: methodClassName) >> methodSelector 
		 
]

{ #category : #displaying }
TWExceptionContext >> displayClassName [
	
	receiverClassName = methodClassName ifTrue: [ ^ methodClassName asString ].
	
	^ receiverClassName asString , ' ( ' , methodClassName asString , ' )'
]

{ #category : #displaying }
TWExceptionContext >> displayMethodName [
	
	^ methodSelector asString
]

{ #category : #accessing }
TWExceptionContext >> executedInterval [
	
	| node |
	node := self compiledMethod ast sourceNodeForPC: instructionPointer.
	^ node start to: node stop
]

{ #category : #accessing }
TWExceptionContext >> instructionPointer [

	^ instructionPointer
]

{ #category : #accessing }
TWExceptionContext >> instructionPointer: anInteger [ 
	
	instructionPointer := anInteger 
]

{ #category : #testing }
TWExceptionContext >> isBlockContext [
	
	^ false
]

{ #category : #accessing }
TWExceptionContext >> methodClassName [

	^ methodClassName
]

{ #category : #accessing }
TWExceptionContext >> methodClassName: aString [ 
	
	methodClassName := aString 
]

{ #category : #accessing }
TWExceptionContext >> methodSelector [

	^ methodSelector
]

{ #category : #accessing }
TWExceptionContext >> methodSelector: aString [ 
	
	methodSelector := aString 
]

{ #category : #accessing }
TWExceptionContext >> printOn: aStream [

	| classNameToPrint |
	
	methodClassName = receiverClassName 
		ifTrue: [ classNameToPrint := methodClassName  ]
		ifFalse: [ classNameToPrint := receiverClassName , '(' , methodClassName , ')' ].

	super printOn: aStream.
	aStream 
		nextPut: $(;
		space;
		print: classNameToPrint;
		nextPutAll: ' >> ';
		print: methodSelector;
		space;
		nextPut: $)		
]

{ #category : #accessing }
TWExceptionContext >> receiverClassName [

	^ receiverClassName
]

{ #category : #accessing }
TWExceptionContext >> receiverClassName: aString [ 
	
	receiverClassName := aString 
]

{ #category : #accessing }
TWExceptionContext >> sender [

	^ sender
]

{ #category : #accessing }
TWExceptionContext >> sender: aValue [ 
	
	sender := aValue
]
