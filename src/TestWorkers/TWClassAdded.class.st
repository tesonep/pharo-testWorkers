Class {
	#name : #TWClassAdded,
	#superclass : #TWAbstractChange,
	#category : #'TestWorkers-Changes'
}

{ #category : #accessing }
TWClassAdded >> fromAnnouncement: aClassAdded [

	super fromAnnouncement: aClassAdded.
	definition := aClassAdded classAffected definition
]
