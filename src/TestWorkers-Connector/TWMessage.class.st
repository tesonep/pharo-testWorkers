Class {
	#name : #TWMessage,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'messageFrame'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #private }
TWMessage >> addAdditionalHeaders: frame [

	frame headerAt: 'uuid' put: uuid

]

{ #category : #sending }
TWMessage >> execute: client [

	^ self subclassResponsibility
]

{ #category : #sending }
TWMessage >> handleSendError: anError on: connection [

	anError pass
]

{ #category : #sending }
TWMessage >> initialize [ 
	
	super initialize.
	uuid := UUID new asString
]

{ #category : #accessing }
TWMessage >> messageFrame: aFrame [

	messageFrame := aFrame
]

{ #category : #sending }
TWMessage >> queueName [

	self subclassResponsibility 
	
]

{ #category : #sending }
TWMessage >> sendOn: connection [

	^ self sendOn: connection to: self queueName
]

{ #category : #sending }
TWMessage >> sendOn: connection to: aQueueName [

	| frame |

	[	(frame := connection newSendFrameTo: aQueueName)
			bytes: self serializedData.
		
		self addAdditionalHeaders: frame.
		connection write: frame] onErrorDo: [ :e | self handleSendError: e on: connection ].
	
]

{ #category : #sending }
TWMessage >> serializedData [

	^ ByteArray streamContents: [ :s | 
		  FLSerializer serialize: self on: s ]
]

{ #category : #accessing }
TWMessage >> uuid [
	^ uuid
]

{ #category : #accessing }
TWMessage >> uuid: anObject [
	uuid := anObject
]
