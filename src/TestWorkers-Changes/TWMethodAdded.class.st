Class {
	#name : #TWMethodAdded,
	#superclass : #TWAbstractMethodModification,
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #accessing }
TWMethodAdded >> fromAnnouncement: aMethodAdded [

	super fromAnnouncement: aMethodAdded.
	definition := aMethodAdded methodAdded sourceCode.
	protocol := aMethodAdded methodAdded protocol.

]
