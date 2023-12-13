Class {
	#name : #TWCollectChangesInMemoryCommitTest,
	#superclass : #TWChangesTest,
	#category : #'TestWorkers-Changes-Tests'
}

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
	self
		newClass: #TWExistingClass
		superclass: TestCase
		with: #( a )
		uses: #(  ).
	newDefinition := existingClass definitionString.

	change := self findChangeOf: #TWExistingClass.
	self assert: change newDefinition equals: newDefinition
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAClassHasTheOldDefinition [

	| oldDefinition change |
	oldDefinition := existingClass definitionString.

	self
		newClass: #TWExistingClass
		superclass: TestCase
		with: #( a )
		uses: #(  ).

	change := self findChangeOf: #TWExistingClass.
	self assert: change oldDefinition equals: oldDefinition
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAClassProduceAChangeForTheClass [

	self newClass: #TWExistingClass superclass: TestCase with: #(a) uses: #().
	self assertCommitHasChangeOf: #TWExistingClass

]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodAndProtocolHasTheNewDefinition [

	| change |
	existingClass compile: 'existingMethod ^ 1' classified: 'a-protocol' notifying: nil.

	change := self findChangeOf: #TWExistingClass.
	self assert: change definition equals: 'existingMethod ^ 1'
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodAndProtocolHasTheOldDefinition [

	| change |
	existingClass compile: 'existingMethod ^ 1' classified: 'a-protocol' notifying: nil.

	change := self findChangeOf: #TWExistingClass.
	self assert: change oldDefinition equals: 'existingMethod ^ 31'
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodAndProtocolProducesASingleChange [

	existingClass compile: 'existingMethod ^ 1' classified: 'a-protocol' notifying: nil.

	self assert: repository currentCommit changes size equals: 1
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodHasTheNewDefinition [

	| change |
	existingClass compile: 'existingMethod ^ 1'.

	change := self findChangeOf: #TWExistingClass.
	self assert: change definition equals: 'existingMethod ^ 1'
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodHasTheNewProtocol [

	| change |
	existingClass compile: 'existingMethod ^ 1' classified: 'a-protocol' notifying: nil.

	change := self findChangeOf: #TWExistingClass.
	self assert: change protocol equals: 'a-protocol'
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodHasTheOldDefinition [

	| change |
	existingClass compile: 'existingMethod ^ 1'.

	change := self findChangeOf: #TWExistingClass.
	self assert: change oldDefinition equals: 'existingMethod ^ 31'
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingAMethodProducesAChangeInTheClass [

	existingClass compile: 'existingMethod ^ 1'.
	self assertCommitHasChangeOf: #TWExistingClass

]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingTheProtocolOfAMethodHasTheNewProtocol [

	| change |
	existingClass compile: 'existingMethod ^ 31' classified: 'a-protocol' notifying: nil.

	change := self findChangeOf: #TWExistingClass.
	self assert: change protocol equals: 'a-protocol'
]

{ #category : #'tests - modifying' }
TWCollectChangesInMemoryCommitTest >> testChangingTheProtocolOfAMethodHasTheOldProtocol [

	| change |
	existingClass compile: 'existingMethod ^ 31' classified: 'a-protocol' notifying: nil.

	change := self findChangeOf: #TWExistingClass.
	self assert: change oldProtocol equals: #'a-protocol'
]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testCreatingAClassIncludesDefinition [

	| change aClass |
	aClass := self
		          newClass: #TWAClass
		          superclass: TestCase
		          with: #(  )
		          uses: #(  ).

	change := self findChangeOf: #TWAClass.
	self assert: change definition equals: aClass definitionString
]

{ #category : #'tests - adding' }
TWCollectChangesInMemoryCommitTest >> testCreatingAClassProduceAChangeForTheClass [

	self newClass: #TWAClass.
	self assertCommitHasChangeOf: #TWAClass. 
]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAClassHasTheCorrectDefinition [

	| oldDefinition |
	oldDefinition := existingClass definitionString.
	existingClass removeFromSystem.

	self
		assert: (self findChangeOf: #TWExistingClass) oldDefinition
		equals: oldDefinition
]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAClassProducesAChangeForTheClass [

	existingClass removeFromSystem.	

	self assertCommitHasChangeOf: #TWExistingClass.

]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAMethodHasTheOldSource [

	| change |

	existingClass removeSelector: #existingMethod.

	change := self findChangeOf: #TWExistingClass.
	self assert: change definition equals: 'existingMethod ^ 31'	
]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAMethodHasTheProtocol [

	<expectedFailure>

	"This test is failing as the change reported by the user already lost the old protocol"

	| change |

	existingClass removeSelector: #existingMethod.

	change := self findChangeOf: #TWExistingClass.
	self assert: change protocol equals: 'a-protocol'
]

{ #category : #'tests - removing' }
TWCollectChangesInMemoryCommitTest >> testRemovingAMethodProduceAChangeForTheClass [

	existingClass removeSelector: #existingMethod.
	self assertCommitHasChangeOf: #TWExistingClass. 
]

{ #category : #tests }
TWCollectChangesInMemoryCommitTest >> testWeAreInAValidCommit [

	self deny: repository currentCommit isInvalid
]
