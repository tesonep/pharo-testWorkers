Class {
	#name : #TWCollectChangesInMemoryCommitTest,
	#superclass : #TWRepositoryTest,
	#instVars : [
		'existingClass'
	],
	#category : #'TestWorkers-Tests'
}

{ #category : #asserting }
TWCollectChangesInMemoryCommitTest >> assertCommitHasChangeOf: aClassName [
	self
		assert:
			(repository currentCommit changes
				anySatisfy: [ :aChange | aChange className = aClassName ])
		description: 'Expecting to find a change for ' , aClassName
]

{ #category : #utils }
TWCollectChangesInMemoryCommitTest >> changes [

	^ repository currentCommit changes
]

{ #category : #utils }
TWCollectChangesInMemoryCommitTest >> findChangeOf: aName [.

	^ self changes detect: [ :aChange | aChange className = aName ].
]

{ #category : #running }
TWCollectChangesInMemoryCommitTest >> setUp [ 

	super setUp.

	existingClass := self newClass: #TWExistingClass.

	"Starting a transaction to be in a Memory Commit"
	repository startTransaction 
]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testAddingAMethodIncludesProtocol [

	| change |
	existingClass compile: 'm1 ^ 42' classified: 'a-protocol'.

	change := self findChangeOf: #TWExistingClass.
	self assert: change protocol equals: 'a-protocol'
]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testAddingAMethodIncludesSourceCode [

	| change |
	existingClass compile: 'm1 ^ 42'.

	change := self findChangeOf: #TWExistingClass.
	self assert: change sourceCode equals: 'm1 ^ 42'
]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testAddingAMethodProduceAChangeForTheClass [

	existingClass compile: 'm1 ^ 42'.
	self assertCommitHasChangeOf: #TWExistingClass. 
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAClassHasTheNewDefinition [

	| newDefinition change |
	
	self newClass: #TWExistingClass superclass: TestCase with: #(a) uses: #().
	newDefinition := existingClass definition.

	change := self findChangeOf: #TWExistingClass.
	self assert: change newDefinition equals: newDefinition
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAClassHasTheOldDefinition [

	| oldDefinition change |
	
	oldDefinition := existingClass definition.

	self newClass: #TWExistingClass superclass: TestCase with: #(a) uses: #().

	change := self findChangeOf: #TWExistingClass.
	self assert: change oldDefinition equals: oldDefinition
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAClassProduceAChangeForTheClass [

	self newClass: #TWExistingClass superclass: TestCase with: #(a) uses: #().
	self assertCommitHasChangeOf: #TWExistingClass

]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testCreatingAClassIncludesDefinition [

	| change aClass |
	aClass := self newClass: #TWAClass superclass: TestCase with: #() uses: #().

	change := self findChangeOf: #TWAClass.
	self assert: change definition equals: aClass definition
]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testCreatingAClassProduceAChangeForTheClass [

	self newClass: #TWAClass.
	self assertCommitHasChangeOf: #TWAClass. 
]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAClassHasTheCorrectDefinition [

	| oldDefinition |
	oldDefinition := existingClass definition.
	existingClass removeFromSystem.	

	self assert: (self findChangeOf: #TWExistingClass) oldDefinition equals: oldDefinition
]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAClassProducesAChangeForTheClass [

	existingClass removeFromSystem.	

	self assertCommitHasChangeOf: #TWExistingClass.

]

{ #category : #tests }
TWCollectChangesInMemoryCommitTest >> testWeAreInAValidCommit [

	self deny: repository currentCommit isInvalid
]
