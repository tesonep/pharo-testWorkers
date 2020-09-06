Class {
	#name : #TWMethodModified,
	#superclass : #TWAbstractMethodModification,
	#instVars : [
		'oldDefinition',
		'oldProtocol'
	],
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #accessing }
TWMethodModified >> fromAnnouncement: aMethodModified [

	super fromAnnouncement: aMethodModified.
	
	oldDefinition := aMethodModified oldMethod sourceCode.
	oldProtocol := aMethodModified oldMethod protocol.

	definition := aMethodModified newMethod sourceCode.
	protocol := aMethodModified newMethod protocol.
	
]

{ #category : #accessing }
TWMethodModified >> fromRecategorization: aMethodRecategorized [

	super fromAnnouncement: aMethodRecategorized.
	
	oldDefinition := aMethodRecategorized method sourceCode.
	oldProtocol := aMethodRecategorized oldProtocol.

	definition := aMethodRecategorized method sourceCode.
	protocol := aMethodRecategorized newProtocol.
	
]

{ #category : #testing }
TWMethodModified >> isMethodModified [

	^ true
]

{ #category : #accessing }
TWMethodModified >> oldDefinition [
	
	^ oldDefinition
]

{ #category : #accessing }
TWMethodModified >> oldProtocol [
	^ oldProtocol
]

{ #category : #accessing }
TWMethodModified >> updateFromAnnouncement: aMethodModified [

	oldDefinition := aMethodModified oldMethod sourceCode
]
