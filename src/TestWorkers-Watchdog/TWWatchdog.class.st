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

{ #category : #testing }
TWWatchdog >> canBeInstance: aDiskDirectoryEntry [ 
	
	^ aDiskDirectoryEntry asFileReference basename asInteger isNotNil
]

{ #category : #'instance creation' }
TWWatchdog >> createInstance: anId [ 

	| directory |
	
	directory := rootDirectory / anId asString.
	directory ensureCreateDirectory.
	templatePath copyAllTo: directory.
]

{ #category : #initialization }
TWWatchdog >> ensureInstances: aNumber [

	instances size >= aNumber ifTrue: [ ^ self ].
	
	1 to: aNumber do: [ :index | 
		(instances anySatisfy: [ :e | e id = index ]) 
			ifFalse: [ self createInstance: index ]].
		
	self readWorkers.
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

{ #category : #initialization }
TWWatchdog >> readWorkers [
	
	| directories |
	directories := rootDirectory entries select: [:e | e isDirectory ].

	instances := directories 
		select: [ :e | self canBeInstance: e ] 
		thenCollect: [ :e | TWWorkerInstance directory: e ].

]

{ #category : #accessing }
TWWatchdog >> rootDirectory [
	^ rootDirectory
]

{ #category : #accessing }
TWWatchdog >> rootDirectory: anObject [
	rootDirectory := anObject
]
