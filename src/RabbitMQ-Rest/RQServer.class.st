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
RQServer >> exchanges [

	^ (self newRequest get: '/api/exchanges') 
			collect: [ :aDictionary | RQExchange fromDictionary: aDictionary and: self ]
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

	^ (self newRequest get: '/api/queues') 
			collect: [ :aDictionary | RQQueue fromDictionary: aDictionary and: self ]
]

{ #category : #accessing }
RQServer >> username [
	^ username
]

{ #category : #accessing }
RQServer >> username: anObject [
	username := anObject
]
