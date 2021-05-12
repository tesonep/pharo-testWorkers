Class {
	#name : #TWRunner,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'watched',
		'messagesSent'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'TestWorkers-Worker'
}

{ #category : #'instance creation' }
TWRunner class >> reset [
	UniqueInstance := nil.
]

{ #category : #'instance creation' }
TWRunner class >> uniqueInstance [

	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #operations }
TWRunner >> doExecuteTestCaseNamed: testClassName [

	| testClass testResults |
	testClass := self class environment at: testClassName.
	Author
		useAuthor: 'TWRunner'
		during: [ 
			
			[ testResults := testClass buildSuite run ] 
				on: Notification do: [ :e | 
					UIManager default logError: e.
					e resume. ] ].
	^ testResults
]

{ #category : #operations }
TWRunner >> doRunTestMessage: aTWMessage [

	self traceTestMessage: aTWMessage.

	^ [ self executionResponseOf: aTWMessage withResult: (self doExecuteTestCaseNamed: aTWMessage testClassName asSymbol) ]
		on: Exception
		do: [ :anError | self executionErrorResponseOf: aTWMessage withError: anError ]
]

{ #category : #operations }
TWRunner >> executionErrorResponseOf: aTWMessage withError: anError [

	^ TWTestExecutionError new
		  testClassName: aTWMessage testClassName;
		  exceptionMessage:
			  anError class name printString , anError messageText printString;
		  serializedException: nil;
		  uuid: aTWMessage uuid;
		  yourself
]

{ #category : #operations }
TWRunner >> executionResponseOf: aTWMessage withResult: testResults [

	^ TWTestResponse new
		  testResults: testResults;
		  testClassName: aTWMessage testClassName;
		  uuid: aTWMessage uuid;
		  yourself
]

{ #category : #operations }
TWRunner >> handleMaybeDuplicateOf: aTWMessage answering: aValuable [

	| answer |

	messagesSent
		at: aTWMessage uuid
		ifPresent: [ :message | ^ message sendOn: connection ].

	answer := aValuable value.

	messagesSent at: aTWMessage uuid put: answer.
	answer sendOn: connection
]

{ #category : #configuration }
TWRunner >> inputQueueName [ 

	^ 'testRequest'
]

{ #category : #configuration }
TWRunner >> processName [ 

	^ 'TWRunner'
]

{ #category : #operations }
TWRunner >> runTestMessage: aTWMessage [

	self handleMaybeDuplicateOf: aTWMessage answering: [ self doRunTestMessage: aTWMessage ]

]

{ #category : #operations }
TWRunner >> startWatched [

	| oldChanges uuid oldChangesRef newChanges |
	uuid := UUID new asString.
	Smalltalk logFileName: 'PharoDebug' , uuid , '.log'.
	oldChanges := SourceFiles changesFileStream.
	oldChanges close.
	oldChangesRef := oldChanges path asFileReference.
	newChanges := oldChangesRef parent / oldChangesRef basenameWithoutExtension , uuid
	        , '.changes'.
	oldChangesRef copyTo: newChanges.
	oldChanges
		path: newChanges pathString;
		tryOpen.
	
	messagesSent := Dictionary new.
	self start.
	watched := TWWatched new.
	watched start
]

{ #category : #operations }
TWRunner >> stop [ 
	
	super stop.
	watched ifNotNil: [ watched stop. watched := nil ].
]

{ #category : #operations }
TWRunner >> traceTestMessage: aTWMessage [

	self traceCr: DateAndTime now asString , 'runTestMessage: class'
		, aTWMessage testClassName , ' uuid: ' , aTWMessage uuid
]
