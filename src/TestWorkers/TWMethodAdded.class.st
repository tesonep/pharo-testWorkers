Class {
	#name : #TWMethodAdded,
	#superclass : #TWAbstractChange,
	#instVars : [
		'protocol'
	],
	#category : #'TestWorkers-Changes'
}

{ #category : #accessing }
TWMethodAdded >> fromAnnouncement: aMethodAdded [

	super fromAnnouncement: aMethodAdded.
	definition := aMethodAdded methodAdded sourceCode.
	protocol := aMethodAdded methodAdded protocol.

]

{ #category : #accessing }
TWMethodAdded >> protocol [
	^ protocol
]

{ #category : #accessing }
TWMethodAdded >> sourceCode [

	^ definition
]
