Class {
	#name : #TWRunner,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'watched'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'TestWorkers-Runner'
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
	
	[aTWMessage testClassName traceCr.
	
	testClass := self class environment at: aTWMessage testClassName asSymbol.
	testResults := testClass buildSuite run.
		
	TWTestResponse new
		testResults: testResults;
		testClassName: aTWMessage testClassName;
		uuid: aTWMessage uuid;
		sendOn: connection.] onErrorDo: [ :anError | 
		
			TWTestExecutionError new
				testClassName: aTWMessage testClassName;
				exceptionMessage: anError messageText;
				serializedException: nil;
				uuid: aTWMessage uuid;
				sendOn: connection 
	]
]

{ #category : #operations }
TWRunner >> startWatched [

	self start.
	watched := TWWatched new.
	watched start.
]

{ #category : #operations }
TWRunner >> stop [ 
	
	super stop.
	watched ifNotNil: [ watched stop. watched := nil ].
]
