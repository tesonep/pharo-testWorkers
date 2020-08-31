Class {
	#name : #TWWatchdog,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'rootDirectory',
		'templatePath',
		'instances'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'as yet unclassified' }
TWWatchdog class >> onRootDirectory: aFileReference [
	
	^ self basicNew
		rootDirectory: aFileReference;
		initialize;
		yourself
]

{ #category : #initialization }
TWWatchdog >> ensureTemplate [
	
	templatePath exists ifFalse: [ templatePath ensureCreateDirectory ].
	(templatePath / 'Pharo.image') exists ifFalse: [ ^ self halt ].
]

{ #category : #accessing }
TWWatchdog >> initialize [

	super initialize.
	templatePath := rootDirectory / 'template'.

	self ensureTemplate.
	self readWorkers.
]

{ #category : #accessing }
TWWatchdog >> rootDirectory [
	^ rootDirectory
]

{ #category : #accessing }
TWWatchdog >> rootDirectory: anObject [
	rootDirectory := anObject
]
