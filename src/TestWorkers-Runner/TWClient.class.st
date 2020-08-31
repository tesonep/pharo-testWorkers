Class {
	#name : #TWClient,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'requests',
		'testResult',
		'onUpdateBlock'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #'instance creation' }
TWClient class >> uniqueInstance [

	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #initialization }
TWClient >> initialize [

	super initialize.
	requests := Dictionary new.
	testResult := TestResult new.
]

{ #category : #configuration }
TWClient >> inputQueueName [ 

	^ 'testResponse'
]

{ #category : #events }
TWClient >> onUpdate: aValuable [

	onUpdateBlock := aValuable.
]

{ #category : #processing }
TWClient >> processMessage: aStampMessageFrame [

	| message |
	
	[ 
		message := STON fromString: aStampMessageFrame body.
		message execute: self.
		connection write: aStampMessageFrame ackFrame 
	]	onErrorDo: [:e | | nackFrame |
			nackFrame := aStampMessageFrame nackFrame.
			connection write: nackFrame ].
	
	
]

{ #category : #accessing }
TWClient >> requests [
	^ requests
]

{ #category : #initialization }
TWClient >> resetResults [

	testResult := TestResult new.
	requests := Dictionary new
	
]

{ #category : #operations }
TWClient >> runTestClass: aTestCase [

	| request |
	
	request := TWTestRequest new
		testClassName: aTestCase name;
		sendOn: connection;
		yourself.
		
	requests at: request uuid put: request.
		
	
]

{ #category : #operations }
TWClient >> runTestResponse: aTWTestResponse [

	requests removeKey: aTWTestResponse uuid ifAbsent: [ ^ self ].
	testResult mergeWith: aTWTestResponse testResults.
	
	onUpdateBlock ifNotNil: [ UIManager default defer: onUpdateBlock ]
]

{ #category : #configuration }
TWClient >> serverHost [

	^ 'localhost'
]

{ #category : #configuration }
TWClient >> serverPort [

	^ 61613
]

{ #category : #accessing }
TWClient >> testResults [

	^ testResult
]
