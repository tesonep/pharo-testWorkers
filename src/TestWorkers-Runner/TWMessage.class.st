Class {
	#name : #TWMessage,
	#superclass : #Object,
	#instVars : [
		'uuid'
	],
	#category : #'TestWorkers-Runner'
}

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

{ #category : #sending }
TWMessage >> queueName [

	self subclassResponsibility 
	
]

{ #category : #sending }
TWMessage >> sendOn: connection [

	| frame |

	[(frame := connection newSendFrameTo: self queueName)
		bytes: self serializedData;
		headerAt: 'uuid' put: uuid. 
		
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
