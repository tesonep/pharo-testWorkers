Class {
	#name : #TWTestCaseResult,
	#superclass : #Object,
	#instVars : [
		'testClassName',
		'testSelector',
		'isExpectedFailure',
		'exceptionMessage',
		'exceptionStack',
		'exceptionDebugString'
	],
	#category : #'TestWorkers-Connector-Results'
}

{ #category : #'instance creation' }
TWTestCaseResult class >> from: aTWFailingTest [ 
	
	^ self new
		testClassName: aTWFailingTest class name;
		testSelector: aTWFailingTest selector;
		isExpectedFailure: aTWFailingTest isExpectedFailure;
		yourself
		
]

{ #category : #initialization }
TWTestCaseResult >> convertContext: aContext upTo: cuttingContext [ 
	
	"We have arrived to the top of the stack"
	aContext ifNil: [ ^ nil ].

	"We have arrived to the cutting context"
	aContext = cuttingContext ifTrue: [ ^ nil ].
	
	aContext method isCompiledBlock 
		ifTrue: [
			^ TWExceptionBlockContext new
				blockSourceCode: aContext method sourceNode sourceCode;
				blockSourceCodeStart: aContext method sourceNode start;
				blockSourceCodeStop: aContext method sourceNode stop;
				blockLiteralIndex: (aContext method outerCode allLiterals indexOf: aContext method);
				currentNodeInOuterStart: (aContext method sourceNodeForPC: aContext pc) start; 
				currentNodeInOuterStop: (aContext method sourceNodeForPC: aContext pc) stop;
				methodClassName: aContext method method methodClass name;
				methodSelector: aContext method method selector;
				instructionPointer: aContext pc;
				sender: (self convertContext: aContext sender upTo: cuttingContext);
				yourself	].
	
	^ TWExceptionContext new
		methodClassName: aContext method methodClass name;
		receiverClassName: aContext receiver class name;
		methodSelector: aContext method selector;
		instructionPointer: aContext pc;
		sender: (self convertContext: aContext sender upTo: cuttingContext);
		yourself
]

{ #category : #ui }
TWTestCaseResult >> drTestsBrowse [

	Smalltalk tools browser
		openOnClass: (self class environment classNamed: testClassName)
		selector: testSelector
]

{ #category : #ui }
TWTestCaseResult >> drTestsName [

	self hasException ifFalse: [ 
		^ testClassName asString , ' >> ' , testSelector asString ].
	
	^ String streamContents: [ :s | 
		s 
			nextPutAll: testClassName asString;
			nextPutAll: ' >> ';
			nextPutAll: testSelector asString;
			nextPutAll: ' --> ';
			nextPutAll: self exceptionClassName asString;
			nextPutAll: ': ';
			nextPutAll: self exceptionMessage	]
	

]

{ #category : #accessing }
TWTestCaseResult >> exceptionClassName [
	
	"The exception class is the class of the receiver in signaling context"
	^ exceptionStack receiverClassName
]

{ #category : #accessing }
TWTestCaseResult >> exceptionDebugString [

	^ exceptionDebugString
]

{ #category : #accessing }
TWTestCaseResult >> exceptionMessage [
	
	^ exceptionMessage
]

{ #category : #accessing }
TWTestCaseResult >> exceptionStack [
	^ exceptionStack
]

{ #category : #accessing }
TWTestCaseResult >> hasException [

	^ exceptionStack isNotNil
]

{ #category : #accessing }
TWTestCaseResult >> isExpectedFailure [
	
	^ isExpectedFailure
]

{ #category : #accessing }
TWTestCaseResult >> isExpectedFailure: aValue [
	
	isExpectedFailure := aValue
]

{ #category : #printing }
TWTestCaseResult >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $(;
		space;
		print: testClassName;
		space;
		print: testSelector;
		space;
		nextPut: $)
	
]

{ #category : #testing }
TWTestCaseResult >> shouldPass [
	
	^ isExpectedFailure not
]

{ #category : #accessing }
TWTestCaseResult >> stackTrace [
	
	| current |
	current := self exceptionStack.
	
	^ OrderedCollection streamContents: [ :s |
		[current isNil] whileFalse: [
		   s nextPut: current. 
			current := current sender ]]
]

{ #category : #initializing }
TWTestCaseResult >> storeError: anException upTo: executingContext [
	exceptionMessage := anException messageText.
	exceptionStack := self convertContext: anException signalContext
				upTo: executingContext.
	exceptionDebugString := String
				streamContents: [:s | anException signalContext debugStackOn: s]
]

{ #category : #accessing }
TWTestCaseResult >> testClassName [
	^ testClassName
]

{ #category : #accessing }
TWTestCaseResult >> testClassName: aString [ 
	
	testClassName := aString 
]

{ #category : #accessing }
TWTestCaseResult >> testSelector [
	^ testSelector
]

{ #category : #accessing }
TWTestCaseResult >> testSelector: aString [ 
	
	testSelector := aString 
]
