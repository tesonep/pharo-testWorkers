Class {
	#name : #TWMessage,
	#superclass : #Object,
	#instVars : [
		'uuid'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #converting }
TWMessage >> asRequestBody [

	^  STON toString: self.
]

{ #category : #sending }
TWMessage >> execute: client [

	^ self subclassResponsibility
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

	(frame := connection newSendFrameTo: self queueName)
		text: self asRequestBody;
		headerAt: 'uuid' put: uuid. 
		
	connection write: frame.

	
]

{ #category : #accessing }
TWMessage >> uuid [
	^ uuid
]

{ #category : #accessing }
TWMessage >> uuid: anObject [
	uuid := anObject
]
