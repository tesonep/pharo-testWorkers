Class {
	#name : #TWMessageLogger,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWMessageLogger class >> current [

	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #'settings api' }
TWMessageLogger >> logEntry: aFrame [

	self logStreamDo: [ :s | s << aFrame printString; cr; flush ].
]

{ #category : #'settings api' }
TWMessageLogger >> logFileName [ 

	^ (FileLocator workingDirectory / Smalltalk logFileName) asFileReference withExtension: 'messages.log'
]

{ #category : #'settings api' }
TWMessageLogger >> logStreamDo: aBlock [

	stream ifNotNil: [ ^ aBlock value: stream ].

	self logFileName writeStreamDo: [ :s | 
		s setToEnd.
		aBlock value: s ]

]

{ #category : #registering }
TWMessageLogger >> register [
	
	StampLogEvent announcer when: StampLogEvent send: #logEntry: to: self
]

{ #category : #accessing }
TWMessageLogger >> stream [

	^ stream
]

{ #category : #accessing }
TWMessageLogger >> stream: anObject [

	stream := anObject
]
