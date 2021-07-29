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

{ #category : #initialization }
TWClient >> executionErrors [

	^ executionErrors 
]

{ #category : #'getting-info' }
TWClient >> findWorkerExchanges [

	^ self rqServer exchanges
		  select: [ :anExchange | anExchange name beginsWith: 'workers' ]
		  thenCollect: [ :anExchange | '/exchange/' , anExchange name ]
]

{ #category : #'as yet unclassified' }
TWClient >> idleWatchdog [

	((self queueNamed: 'testRequest') messages = 0)
		ifTrue: [ self sendMissingRequests ] 
]

{ #category : #information }
TWClient >> informationArrived: aTWInfoResponse [

	workerInstances
		at: aTWInfoResponse instanceId
		put: (TWWorkerInstance for: aTWInfoResponse)
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

{ #category : #operations }
TWClient >> purgePendingMessages [

	(self queueNamed: 'testRequest') purge
]

{ #category : #accessing }
TWClient >> repository [
	^ repository
]

{ #category : #operations }
TWClient >> requestInstanceInfo [

	| exchanges |
	
	exchanges := self findWorkerExchanges.
	exchanges do: [ :anExchange | [TWRequestInfo new sendOn: connection to: anExchange] onErrorDo: [  ]]
	
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

{ #category : #running }
TWClient >> runSingleTest: aSingleTest [ 

	| request |
	
	request := TWSingleTestRequest new
		testClassName: aSingleTest testClass name;
		testSelector: aSingleTest testSelector;
		yourself.
		
	requests at: request uuid asString put: request.
	
	"RabbitMQ likes to close the connection. This ensures we retry until we are able to connect again."
	self ensureNetworkSuccess: [ request sendOn: connection ]

		
]

{ #category : #operations }
TWClient >> runTestClass: aTestCase [

	| request |
	
	request := TWTestRequest new
		testClassName: aTestCase name;
		yourself.
		
	requests at: request uuid asString put: request.
	
	"RabbitMQ likes to close the connection. This ensures we retry until we are able to connect again."
	self ensureNetworkSuccess: [ request sendOn: connection ]

	
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

{ #category : #'as yet unclassified' }
TWClient >> sendMissingRequests [
	
	requests do: [ :request |
		self ensureNetworkSuccess: [ request sendOn: connection ] ]
]

{ #category : #operations }
TWClient >> setSubscriptionOptions [

	self subscription 
		clientIndividualAck;
		prefetchCount: 10.
	
]

{ #category : #accessing }
TWClient >> testResults [

	^ testResult
]
