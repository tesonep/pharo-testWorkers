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

	connection timeout: 5.
	connection open.

	subscription := connection newSubscriptionTo: self inputQueueName.

	self setSubscriptionOptions.
	
	connection write: subscription subscribeFrame.
	
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
		do: []]
		on: NetworkError
		do:
			[:e |
			| nackFrame |
			[connection isConnected] whileFalse: [self doConnect].
			listenerProcess isActiveProcess ifFalse: [self startListener].
			msg
				ifNotNil:
					[nackFrame := msg nackFrame.
					[connection write: nackFrame] onErrorDo: []]]]
		on: Error
		do: []
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
		  self processRequest ] repeat ] forkAt: self processPriority named: self processName.
]

{ #category : #operations }
TWAbstractConnected >> stop [

	[connection close] on: ZnIncomplete, Error do: [ 
		"If the message is incomplete I don't care"
		"I am closing it" ].
	
	listenerProcess ifNotNil: [ listenerProcess terminate ].
]

{ #category : #configuration }
TWAbstractConnected >> username [

	^ self class username
]
