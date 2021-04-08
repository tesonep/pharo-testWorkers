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

	| testResults testClass answer |
	messagesSent
		at: aTWMessage uuid
		ifPresent: [ :message | ^ message sendOn: connection ].
	answer := [ 
	          self traceCr:
		          DateAndTime now asString , 'runTestMessage: class'
		          , aTWMessage testClassName , ' uuid: ' , aTWMessage uuid.

	          testClass := self class environment at:
		                       aTWMessage testClassName asSymbol.
		
				 Author useAuthor: 'TWRunner' during: [ testResults := testClass buildSuite run ].

	          TWTestResponse new
		          testResults: testResults;
		          testClassName: aTWMessage testClassName;
		          uuid: aTWMessage uuid;
		          yourself ]
		          on: Exception
		          do: [ :anError | 
			          TWTestExecutionError new
				          testClassName: aTWMessage testClassName;
				          exceptionMessage: anError class name printString , anError messageText printString;
				          serializedException: nil;
				          uuid: aTWMessage uuid;
				          yourself ].
	messagesSent at: aTWMessage uuid put: answer.
	answer sendOn: connection
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
