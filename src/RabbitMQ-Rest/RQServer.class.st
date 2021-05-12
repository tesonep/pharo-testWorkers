Class {
	#name : #RQServer,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'username',
		'password'
	],
	#category : #'RabbitMQ-Rest'
}

{ #category : #api }
RQServer >> connections [

	^ self from: '/api/connections' as: RQConnection

]

{ #category : #api }
RQServer >> exchanges [

	^ self from: '/api/exchanges' as: RQExchange
]

{ #category : #private }
RQServer >> from: aPath as: anEntityClass [
	
	^ (self newRequest get: aPath) 
			collect: [ :aDictionary | anEntityClass fromDictionary: aDictionary and: self ].
			

]

{ #category : #accessing }
RQServer >> host [
	^ host
]

{ #category : #accessing }
RQServer >> host: anObject [
	host := anObject
]

{ #category : #initialization }
RQServer >> initialize [

	super initialize.
	host := 'localhost'.
	port := 15672.
	username := 'guest'.
	password := 'guest'.
]

{ #category : #private }
RQServer >> newRequest [

	^ RQApiRequest new
		host: host;
		port: port;
		username: username;
		password: password;
		yourself.
]

{ #category : #accessing }
RQServer >> password [
	^ password
]

{ #category : #accessing }
RQServer >> password: anObject [
	password := anObject
]

{ #category : #accessing }
RQServer >> port [
	^ port
]

{ #category : #accessing }
RQServer >> port: anObject [
	port := anObject
]

{ #category : #api }
RQServer >> queues [

	^ self from: '/api/queues' as: RQQueue
]

{ #category : #accessing }
RQServer >> username [
	^ username
]

{ #category : #accessing }
RQServer >> username: anObject [
	username := anObject
]
