Class {
	#name : #TWRunner,
	#superclass : #TWAbstractConnected,
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

{ #category : #operations }
TWRunner >> runTestMessage: aTWMessage [

	| testResults testClass |
	
	aTWMessage testClassName traceCr.
	
	testClass := self class environment at: aTWMessage testClassName asSymbol.
	testResults := testClass buildSuite run.
		
	TWTestResponse new
		testResults: testResults;
		testClassName: aTWMessage testClassName;
		uuid: aTWMessage uuid;
		sendOn: connection.
]

{ #category : #configuration }
TWRunner >> serverHost [

	^ 'localhost'
]

{ #category : #configuration }
TWRunner >> serverPort [

	^ 61613
]
