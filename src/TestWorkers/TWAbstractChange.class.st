Class {
	#name : #TWAbstractChange,
	#superclass : #Object,
	#instVars : [
		'className',
		'definition'
	],
	#category : #'TestWorkers-Changes'
}

{ #category : #'instance creation' }
TWAbstractChange class >> fromAnnouncement: anAnnoucement [

	^ self new
		fromAnnouncement: anAnnoucement;
		yourself
]

{ #category : #accessing }
TWAbstractChange >> className [
	^ className
]

{ #category : #accessing }
TWAbstractChange >> className: anObject [
	className := anObject
]

{ #category : #accessing }
TWAbstractChange >> definition [
	^ definition
]

{ #category : #accessing }
TWAbstractChange >> fromAnnouncement: anAnnoucement [

	className := anAnnoucement classAffected name
]

{ #category : #testing }
TWAbstractChange >> isMethodModified [

	^ false
]
