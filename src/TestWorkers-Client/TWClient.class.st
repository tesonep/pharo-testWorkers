Class {
	#name : #TWClient,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'requests',
		'testResult',
		'onUpdateBlock',
		'executionErrors',
		'repository',
		'workerInstances'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'TestWorkers-Client'
}

{ #category : #'instance creation' }
TWClient class >> reset [
	
	UniqueInstance ifNotNil: [ UniqueInstance stop ].
	UniqueInstance := nil
]

{ #category : #'instance creation' }
TWClient class >> uniqueInstance [

	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #information }
TWClient >> informationArrived: aTWInfoResponse [ 
	
	aTWInfoResponse traceCr.
	workerInstances at: aTWInfoResponse instanceId put: aTWInfoResponse.
]

{ #category : #initialization }
TWClient >> initialize [

	super initialize.
	requests := Dictionary new.
	testResult := TestResult new.
	executionErrors := OrderedCollection new.
	repository := TWRepository new.
	repository createInitialCommit.
	workerInstances := Dictionary new.
]

{ #category : #configuration }
TWClient >> inputQueueName [ 

	^ 'testResponse'
]

{ #category : #events }
TWClient >> onUpdate: aValuable [

	onUpdateBlock := aValuable.
]

{ #category : #configuration }
TWClient >> processName [ 

	^ 'TWClient'
]

{ #category : #accessing }
TWClient >> repository [
	^ repository
]

{ #category : #operations }
TWClient >> requestInstanceInfo [

	[TWRequestInfo new sendOn: connection] onErrorDo: [  ]
]

{ #category : #accessing }
TWClient >> requests [
	^ requests
]

{ #category : #initialization }
TWClient >> resetResults [

	testResult := TestResult new.
	requests := Dictionary new.
	executionErrors := OrderedCollection new.
	
]

{ #category : #operations }
TWClient >> runTestClass: aTestCase [

	| request |
	
	request := TWTestRequest new
		testClassName: aTestCase name;
		yourself.
		
	requests at: request uuid asString put: request.
		
	request sendOn: connection

	
]

{ #category : #operations }
TWClient >> runTestExecutionError: aTWTestExecutionError [

	requests removeKey: aTWTestExecutionError uuid asString ifAbsent: [ ^ self ].
	
	executionErrors add: aTWTestExecutionError.
	
	onUpdateBlock ifNotNil: [ UIManager default defer: onUpdateBlock ]
]

{ #category : #operations }
TWClient >> runTestResponse: aTWTestResponse [

	requests removeKey: aTWTestResponse uuid asString 
		ifAbsent: [ ^ self ].
	
	testResult mergeWith: aTWTestResponse testResults.
	
	onUpdateBlock ifNotNil: [ UIManager default defer: onUpdateBlock ]
]

{ #category : #changes }
TWClient >> sendChanges [
	
	repository currentCommit
]

{ #category : #accessing }
TWClient >> testResults [

	^ testResult
]
