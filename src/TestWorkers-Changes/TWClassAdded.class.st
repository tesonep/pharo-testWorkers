Class {
	#name : #TWClassAdded,
	#superclass : #TWAbstractChange,
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #accessing }
TWClassAdded >> fromAnnouncement: aClassAdded [

	super fromAnnouncement: aClassAdded.
	definition := aClassAdded classAffected definition
]
