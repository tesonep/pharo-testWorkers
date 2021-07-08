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
	
	connection isConnected 
		ifTrue: [ connection close ].
		
	connection host: self serverHost.
	connection port: self serverPort.
	connection login: self username.
	connection passcode: self password.

	connection timeout: 5 "seconds".
	connection heartbeat: 5 * 1000 / 2 "miliseconds".
	connection open.

	connection isConnected ifTrue: [ 
		subscription := connection newSubscriptionTo: self inputQueueName.

		self setSubscriptionOptions.
		
		connection write: subscription subscribeFrame.]
	
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
	connection := StampClient new.
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
	message := FLMaterializer materializeFromByteArray: aStampMessageFrame body.
	message messageFrame: aStampMessageFrame.
	message execute: self.
	((aStampMessageFrame headerAt: 'subscription') includesSubstring: '/temp-queue/') 
		ifFalse: [ 
			connection write: aStampMessageFrame ackFrame ]
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
	[
	[
	[msg := connection readMessage.
	self processMessage: msg] on: ZnIncomplete
		do: [:e | self traceError: e]]
		on: NetworkError
		do:
			[:e |
			| nackFrame |
			[connection isConnected] whileFalse: [self doConnect].
			listenerProcess isActiveProcess ifFalse: [self startListener].
			self traceError: e.
			msg
				ifNotNil:
					[nackFrame := msg nackFrame.
					[connection write: nackFrame] onErrorDo: [:x | self traceError: x]]]]
		on: Error
		do: [:e | self traceError: e]
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
	subscription 
		clientIndividualAck;
		prefetchCount: 1.
	
]

{ #category : #operations }
TWAbstractConnected >> start [

	self doConnect.
	self startListener.
]

{ #category : #operations }
TWAbstractConnected >> startListener [
	
	listenerProcess := [ 
		[ connection isConnected 
			ifFalse: [ self doConnect ].
		  connection isConnected
			ifTrue: [ self processRequest ] ] repeat ] 
		forkAt: self processPriority 
		named: self processName.
]

{ #category : #operations }
TWAbstractConnected >> stop [

	[connection close] on: ZnIncomplete, Error do: [ 
		"If the message is incomplete I don't care"
		"I am closing it" ].
	
	listenerProcess ifNotNil: [ listenerProcess terminate ].
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
