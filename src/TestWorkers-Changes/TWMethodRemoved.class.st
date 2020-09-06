Class {
	#name : #TWMethodRemoved,
	#superclass : #TWAbstractMethodModification,
	#instVars : [
		'selector'
	],
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #accessing }
TWMethodRemoved >> fromAnnouncement: anAnnoucement [

	super fromAnnouncement: anAnnoucement.
	definition := anAnnoucement method sourceCode.
	selector := anAnnoucement method selector. 
	className := anAnnoucement method methodClass name. 
	protocol := anAnnoucement method protocol.
]
