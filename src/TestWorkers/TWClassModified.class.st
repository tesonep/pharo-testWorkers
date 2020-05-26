Class {
	#name : #TWClassModified,
	#superclass : #TWAbstractChange,
	#instVars : [
		'oldDefinition'
	],
	#category : #'TestWorkers-Changes'
}

{ #category : #accessing }
TWClassModified >> fromAnnouncement: aClassModified [

	super fromAnnouncement: aClassModified.
	definition := aClassModified classAffected definition.
	oldDefinition := aClassModified oldClassDefinition definition
]

{ #category : #accessing }
TWClassModified >> newDefinition [

	^ definition
]

{ #category : #accessing }
TWClassModified >> oldDefinition [
	^ oldDefinition
]

{ #category : #accessing }
TWClassModified >> oldDefinition: anObject [
	oldDefinition := anObject
]
