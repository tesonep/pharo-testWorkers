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
TWRunner >> doExecuteTestCaseMessage: testMessage [

	| testResults |
	testResults := TWTestResults new.
	
	Author
		useAuthor: 'TWRunner'
		during: [ 			
			[	testResults executingContext: thisContext.
				testMessage buildSuite run: testResults ] 
				on: Notification do: [ :e | e resume. ] ].
	^ testResults
]

{ #category : #operations }
TWRunner >> doRunTestMessage: aTWMessage [

	self traceTestMessage: aTWMessage.

	^ [ self executionResponseOf: aTWMessage withResult: (self doExecuteTestCaseMessage: aTWMessage) ]
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

	^ aTWMessage executionResponseFor: testResults.
	
]

{ #category : #operations }
TWRunner >> handleMaybeDuplicateOf: aTWMessage answering: aValuable [

	| answer |
	messagesSent at: aTWMessage uuid ifPresent: [ :message | 
		self ensureNetworkSuccess: [
			^ message sendOn: connection ] ].

	answer := aValuable value.

	messagesSent at: aTWMessage uuid put: answer.
	
	"Try to send the message until we succeed.
	There is no point in continuing if we have a network error.
	We will probably not be able to get the next message anyways and
	losing the executed message is unacceptable."
	self ensureNetworkSuccess: [ answer sendOn: connection ]
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

	[ connection close "Disconnect because some tests might mess with the connection. This forces us to reconnect, but longer tests will lose the connection anyway." ]
		onErrorDo: [ "Ignore, we want it closed." ].
	[ self handleMaybeDuplicateOf: aTWMessage answering: [ self doRunTestMessage: aTWMessage ] ]
		onErrorDo: [ :e |
			"If there is an unhandled error, requeue the tests message."
			self traceError: e.
			self ensureNetworkSuccess: [ aTWMessage sendOn: connection ] ]

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
