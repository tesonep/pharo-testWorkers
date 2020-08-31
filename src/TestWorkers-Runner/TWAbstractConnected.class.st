Class {
	#name : #TWAbstractConnected,
	#superclass : #Object,
	#instVars : [
		'connection',
		'subscription',
		'listenerProcess'
	],
	#category : #'TestWorkers-Runner'
}

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

	connection timeout: 5.
	connection open.

	subscription := connection newSubscriptionTo: self inputQueueName.

	subscription 
		clientIndividualAck;
		prefetchCount: 1.
	
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

{ #category : #processing }
TWAbstractConnected >> processMessage: aStampMessageFrame [

	| message |
	
	[  message := FLMaterializer materializeFromByteArray: aStampMessageFrame body.
		message execute: self.
		connection write: aStampMessageFrame ackFrame 
	]	onErrorDo: [:e | | nackFrame |
			nackFrame := aStampMessageFrame nackFrame.
			connection write: nackFrame.
			e debug ].
	
	
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

	[[msg := connection readMessage.
	 self processMessage: msg] 
		on: ConnectionTimedOut , ZnIncomplete do: [ ]]
		on: Error do:[:e | 
			self inform: e messageText. connection ].
	
]

{ #category : #configuration }
TWAbstractConnected >> serverHost [

	^ 'localhost'
]

{ #category : #configuration }
TWAbstractConnected >> serverPort [

	^ 61613
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
