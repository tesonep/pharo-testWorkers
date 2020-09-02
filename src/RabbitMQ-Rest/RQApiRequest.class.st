Class {
	#name : #RQApiRequest,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'username',
		'password'
	],
	#category : #'RabbitMQ-Rest'
}

{ #category : #accessing }
RQApiRequest >> delete: aPath [

	| client |

	client := self newClient.

	client 
		path: aPath;
		delete.
	
				
]

{ #category : #accessing }
RQApiRequest >> get: aPath [

	| client |

	client := self newClient.

	client 
		path: aPath;
		get.
	
	^ STONJSON fromString: client contents.
				
]

{ #category : #accessing }
RQApiRequest >> host [
	^ host
]

{ #category : #accessing }
RQApiRequest >> host: anObject [
	host := anObject
]

{ #category : #initialization }
RQApiRequest >> initialize [

	super initialize.
	host := 'localhost'.
	port := 15672.
	username := 'guest'.
	password := 'guest'.
]

{ #category : #accessing }
RQApiRequest >> newClient [ 

	^ ZnClient new
		host: host;
		port: port;
		username: username password: password;
		enforceHttpSuccess: true;
		yourself.
]

{ #category : #accessing }
RQApiRequest >> password [
	^ password
]

{ #category : #accessing }
RQApiRequest >> password: anObject [
	password := anObject
]

{ #category : #accessing }
RQApiRequest >> port [
	^ port
]

{ #category : #accessing }
RQApiRequest >> port: anObject [
	port := anObject
]

{ #category : #operations }
RQApiRequest >> put: aPath contents: contents [ 
	
	| client | 
	
	client := self newClient.
	
	client 
		path: aPath;
		contents: contents;
		put
]

{ #category : #accessing }
RQApiRequest >> username [
	^ username
]

{ #category : #accessing }
RQApiRequest >> username: anObject [
	username := anObject
]
