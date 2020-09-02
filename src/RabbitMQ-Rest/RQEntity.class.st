Class {
	#name : #RQEntity,
	#superclass : #Object,
	#instVars : [
		'dictionary',
		'server'
	],
	#category : #'RabbitMQ-Rest'
}

{ #category : #'instance creation' }
RQEntity class >> fromDictionary: aDictionary and: aRQServer [ 
	
	^ self basicNew
		dictionary: aDictionary;
		server: aRQServer;
		yourself
]

{ #category : #operations }
RQEntity >> delete [

	^ server newRequest
		delete: self deletePath
]

{ #category : #configuration }
RQEntity >> deletePath [

	^ self subclassResponsibility 
]

{ #category : #accessing }
RQEntity >> dictionary [
	^ dictionary ifNil: [ dictionary := Dictionary new ]
]

{ #category : #accessing }
RQEntity >> dictionary: anObject [
	dictionary := anObject
]

{ #category : #accessing }
RQEntity >> name [

	^ dictionary at: #name 
]

{ #category : #accessing }
RQEntity >> name: aValue [

	^ self dictionary at: #name put: aValue
]

{ #category : #accessing }
RQEntity >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		space;
		nextPutAll: self name;
		space;
		nextPut: $)
]

{ #category : #operations }
RQEntity >> save [

	^ server newRequest
		put: self savePath contents: (STONJSON toString: self dictionary)
]

{ #category : #configuration }
RQEntity >> savePath [

	^ self subclassResponsibility 
]

{ #category : #accessing }
RQEntity >> server [
	^ server
]

{ #category : #accessing }
RQEntity >> server: anObject [
	server := anObject
]

{ #category : #accessing }
RQEntity >> vhost [

	^ self dictionary at: #vhost
]

{ #category : #accessing }
RQEntity >> vhost: aValue [

	^ self dictionary at: #vhost put: aValue
]
