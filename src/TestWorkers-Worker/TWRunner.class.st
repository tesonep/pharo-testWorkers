Class {
	#name : #TWRunner,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'watched'
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

	| testResults testClass |
	[ 
	self traceCr: DateAndTime now asString , 'runTestMessage: class'
		, aTWMessage testClassName , ' uuid: ' , aTWMessage uuid.


	testClass := self class environment at:
		             aTWMessage testClassName asSymbol.
	testResults := testClass buildSuite run.

	TWTestResponse new
		testResults: testResults;
		testClassName: aTWMessage testClassName;
		uuid: aTWMessage uuid;
		sendOn: connection ]
		on: Exception
		do: [ :anError | 
			TWTestExecutionError new
				testClassName: aTWMessage testClassName;
				exceptionMessage: anError messageText;
				serializedException: nil;
				uuid: aTWMessage uuid;
				sendOn: connection ]
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
		
	self start.
	watched := TWWatched new.
	watched start
]

{ #category : #operations }
TWRunner >> stop [ 
	
	super stop.
	watched ifNotNil: [ watched stop. watched := nil ].
]
