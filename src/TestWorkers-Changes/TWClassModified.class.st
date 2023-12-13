Class {
	#name : #TWClassModified,
	#superclass : #TWAbstractChange,
	#instVars : [
		'oldDefinition'
	],
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #accessing }
TWClassModified >> fromAnnouncement: aClassModified [

	super fromAnnouncement: aClassModified.
	definition := aClassModified classAffected definitionString.
	oldDefinition := aClassModified oldClassDefinition definitionString
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
