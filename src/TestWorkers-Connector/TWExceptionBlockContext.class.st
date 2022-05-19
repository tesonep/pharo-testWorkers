Class {
	#name : #TWExceptionBlockContext,
	#superclass : #Object,
	#instVars : [
		'blockSourceCode',
		'blockSourceCodeStart',
		'blockSourceCodeStop',
		'blockLiteralIndex',
		'currentNodeInOuterStart',
		'currentNodeInOuterStop',
		'instructionPointer',
		'sender',
		'methodClassName',
		'methodSelector'
	],
	#category : #'TestWorkers-Connector-Results'
}

{ #category : #accessing }
TWExceptionBlockContext >> blockLiteralIndex [

	^ blockLiteralIndex
]

{ #category : #accessing }
TWExceptionBlockContext >> blockLiteralIndex: anInteger [ 
	
	blockLiteralIndex := anInteger 
]

{ #category : #accessing }
TWExceptionBlockContext >> blockSourceCode [

	^ blockSourceCode
]

{ #category : #accessing }
TWExceptionBlockContext >> blockSourceCode: aString [ 
	
	blockSourceCode := aString 
]

{ #category : #accessing }
TWExceptionBlockContext >> blockSourceCodeStart [

	^ blockSourceCodeStart
]

{ #category : #accessing }
TWExceptionBlockContext >> blockSourceCodeStart: anInteger [ 
	
	blockSourceCodeStart := anInteger 
]

{ #category : #accessing }
TWExceptionBlockContext >> blockSourceCodeStop [

	^ blockSourceCodeStop
]

{ #category : #accessing }
TWExceptionBlockContext >> blockSourceCodeStop: anInteger [ 
	
	blockSourceCodeStop := anInteger 
]

{ #category : #accessing }
TWExceptionBlockContext >> compiledMethod [
	
	^ (self class environment classNamed: methodClassName) >> methodSelector 
]

{ #category : #accessing }
TWExceptionBlockContext >> currentNodeInOuterStart [

	^ currentNodeInOuterStart
]

{ #category : #accessing }
TWExceptionBlockContext >> currentNodeInOuterStart: anInteger [ 
	
	currentNodeInOuterStart := anInteger 
]

{ #category : #accessing }
TWExceptionBlockContext >> currentNodeInOuterStop [

	^ currentNodeInOuterStop
]

{ #category : #accessing }
TWExceptionBlockContext >> currentNodeInOuterStop: anInteger [ 
	
	currentNodeInOuterStop := anInteger 
]

{ #category : #accessing }
TWExceptionBlockContext >> displayClassName [
	
	^ methodClassName asString
]

{ #category : #displaying }
TWExceptionBlockContext >> displayMethodName [
	
	^ blockSourceCode 
]

{ #category : #accessing }
TWExceptionBlockContext >> executedInterval [
	
	^ currentNodeInOuterStart to: currentNodeInOuterStop 
]

{ #category : #accessing }
TWExceptionBlockContext >> instructionPointer [

	^ instructionPointer
]

{ #category : #accessing }
TWExceptionBlockContext >> instructionPointer: anInteger [ 
	
	instructionPointer:= anInteger 
]

{ #category : #accessing }
TWExceptionBlockContext >> methodClassName [

	^ methodClassName
]

{ #category : #accessing }
TWExceptionBlockContext >> methodClassName: aString [ 
	methodClassName := aString
]

{ #category : #accessing }
TWExceptionBlockContext >> methodSelector [

	^ methodSelector
]

{ #category : #accessing }
TWExceptionBlockContext >> methodSelector: aString [ 
	methodSelector := aString
]

{ #category : #printing }
TWExceptionBlockContext >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		space;
		print: blockSourceCode;
		nextPutAll: ' in ';
		print: methodClassName;
		space;
		nextPutAll: ' >> '
		space;
		print: methodSelector;
		space;
		nextPut: $)		
]

{ #category : #accessing }
TWExceptionBlockContext >> sender [

	^ sender
]

{ #category : #accessing }
TWExceptionBlockContext >> sender: aValue [ 
	
	sender := aValue
]
