Class {
	#name : #TWAbstractConnected,
	#superclass : #Object,
	#instVars : [
		'connection',
		'subscription',
		'listenerProcess'
	],
	#classVars : [
		'Password',
		'ServerHost',
		'Username'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWAbstractConnected class >> password [
	^ Password ifNil: [ 'guest' ]
]

{ #category : #accessing }
TWAbstractConnected class >> password: anObject [
	Password := anObject
]

{ #category : #accessing }
TWAbstractConnected class >> serverHost [
	^ ServerHost ifNil: [ '127.0.0.1' ]
]

{ #category : #accessing }
TWAbstractConnected class >> serverHost: anObject [
	ServerHost := anObject
]

{ #category : #accessing }
TWAbstractConnected class >> username [
	^ Username ifNil: [ 'guest' ]
]

{ #category : #accessing }
TWAbstractConnected class >> username: anObject [
	Username := anObject
]

{ #category : #accessing }
TWAbstractConnected >> connection [
	^ connection
]

{ #category : #operations }
TWAbstractConnected >> doConnect [

	connection isConnected ifTrue: [ connection close ].

	connection host: self serverHost.
	connection port: self serverPort.
	connection login: self username.
	connection passcode: self password.

	connection timeout: 5. "seconds"
	connection heartbeat: 5 * 1000 / 2. "miliseconds"
	connection clearInbox.
	connection open.

	connection isConnected ifTrue: [ 
		self setSubscriptionOptions.
		connection write: self subscription subscribeFrame ]
]

{ #category : #operations }
TWAbstractConnected >> ensureConnected [
	"Ensure the connection is established.
	Keep in mind that this can itself cause an network or stamp error."

	[ connection isConnected ] whileFalse: [ self doConnect ]
]

{ #category : #operations }
TWAbstractConnected >> ensureNetworkSuccess: aBlock [

	| block |
	"Run the block until it succeeds without a network error, or we get any other error.
	Start by trying three times, and then try once every second."

	block := [ 
		[ [ [ 
		self ensureConnected.
		^ aBlock value ]
			on: StampError
			do: [ :e | self traceError: e ] ]
			on: ZnIncomplete
			do: [ :e | self traceError: e ] ]
			on: NetworkError
			do: [ :e | self traceError: e ]
	].

	1 to: 3 do: [ :i | block value ].

	[
	(Delay forSeconds: 1) wait.
	block value ] repeat

]

{ #category : #operations }
TWAbstractConnected >> ensureStart [

	(connection isConnected and: [ listenerProcess isTerminating not ])
		ifTrue: [ ^ self ].
		
	^ self start
]

{ #category : #initialization }
TWAbstractConnected >> initialize [

	super initialize.
	connection := StampClient new
]

{ #category : #configuration }
TWAbstractConnected >> inputQueueName [ 

	^ self subclassResponsibility 
]

{ #category : #configuration }
TWAbstractConnected >> password [

	^ self class password
]

{ #category : #processing }
TWAbstractConnected >> processMessage: aStampMessageFrame [
	| message |
	
	[
	message := FLMaterializer materializeFromByteArray: aStampMessageFrame body.
	message messageFrame: aStampMessageFrame.

	"We ACK the message as soon as we get it"
	((aStampMessageFrame headerAt: 'subscription')
		includesSubstring: '/temp-queue/')
			ifFalse: [ connection write: aStampMessageFrame ackFrame ] ]
			onErrorDo: [ :e |
				"If there is an error here, send a NACK if possible."
				self traceError: e.
				connection write: aStampMessageFrame nackFrame.
				^self ].
			
	message execute: self

]

{ #category : #configuration }
TWAbstractConnected >> processName [ 

	^ self subclassResponsibility
]

{ #category : #configuration }
TWAbstractConnected >> processPriority [
	
	^ Processor userSchedulingPriority
]

{ #category : #operations }
TWAbstractConnected >> processRequest [

	| msg |
	[msg := connection readMessage.
	self processMessage: msg]
		onErrorDo:
			[:e |
			self traceError: e.
			self ensureConnected.
			listenerProcess isActiveProcess ifFalse: [ self startListener ] ]
]

{ #category : #configuration }
TWAbstractConnected >> queueNamed: aName [
	^self queueNamed: aName ifNone: [self error: 'The queue doesn''t exixts!']
]

{ #category : #configuration }
TWAbstractConnected >> rqServer [

	^ RQServer new
		  host: self serverHost;
		  username: self username;
		  password: self password;
		  yourself
]

{ #category : #configuration }
TWAbstractConnected >> serverHost [

	^ self class serverHost
]

{ #category : #configuration }
TWAbstractConnected >> serverPort [

	^ 61613
]

{ #category : #operations }
TWAbstractConnected >> setSubscriptionOptions [

	self subscription
		clientIndividualAck;
		prefetchCount: 1
]

{ #category : #operations }
TWAbstractConnected >> start [

	self doConnect.
	self startListener.
]

{ #category : #operations }
TWAbstractConnected >> startListener [

	listenerProcess :=
			[ 
			[ self ensureNetworkSuccess: [ self processRequest ] ]
				repeat]
				forkAt: self processPriority
				named: self processName
]

{ #category : #operations }
TWAbstractConnected >> stop [

	[connection close] on: ZnIncomplete, Error do: [ 
		"If the message is incomplete I don't care"
		"I am closing it" ].

	listenerProcess ifNotNil: [ listenerProcess terminate ]
]

{ #category : #operations }
TWAbstractConnected >> subscription [

	^ subscription ifNil: [ 
		  subscription := connection newSubscriptionTo: self inputQueueName ]
]

{ #category : #'tracing errors ' }
TWAbstractConnected >> traceError: anError [ 

	| timestamp |
	timestamp := DateAndTime now.
	
	(String streamContents: [ :stream |
		timestamp printYMDOn: stream.
		stream space.
		timestamp printHMSOn: stream. 
		stream 
			space;
			print: self;
			nextPutAll: ' :: ';
			print: anError
		 ]) traceCr.
	
]

{ #category : #configuration }
TWAbstractConnected >> username [

	^ self class username
]
