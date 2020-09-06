Class {
	#name : #TWChangesTest,
	#superclass : #TWRepositoryTest,
	#instVars : [
		'existingClass'
	],
	#category : #'TestWorkers-Changes-Tests'
}

{ #category : #asserting }
TWChangesTest >> assertCommitHasChangeOf: aClassName [
	self
		assert:
			(repository currentCommit changes
				anySatisfy: [ :aChange | aChange className = aClassName ])
		description: 'Expecting to find a change for ' , aClassName
]

{ #category : #utils }
TWChangesTest >> changes [

	^ repository currentCommit changes
]

{ #category : #utils }
TWChangesTest >> findChangeOf: aName [.

	^ self changes detect: [ :aChange | aChange className = aName ].
]

{ #category : #utils }
TWChangesTest >> initialClassSetup [ 

	existingClass := self newClass: #TWExistingClass.
	existingClass compile: 'existingMethod ^ 31' classified: #'a-protocol'.

]

{ #category : #running }
TWChangesTest >> setUp [ 

	super setUp.

	self initialClassSetup.
	
	"Creates the initial commit"
	repository createInitialCommit.
	"Starting a transaction to be in a Memory Commit"
	repository startTransaction 
]
