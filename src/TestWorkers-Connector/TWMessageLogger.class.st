Class {
	#name : #TWMessageLogger,
	#superclass : #Object,
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

	self logStreamDo: [ :s | s << aFrame printString; crlf ].
]

{ #category : #'settings api' }
TWMessageLogger >> logFileName [ 

	^ (FileLocator workingDirectory / Smalltalk logFileName) asFileReference withExtension: 'messages.log'
]

{ #category : #'settings api' }
TWMessageLogger >> logStreamDo: aBlock [

	self logFileName writeStreamDo: [ :s | 
		s setToEnd.
		aBlock value: s ]

]

{ #category : #registering }
TWMessageLogger >> register [
	
	StampLogEvent announcer when: StampLogEvent send: #logEntry: to: self
]
