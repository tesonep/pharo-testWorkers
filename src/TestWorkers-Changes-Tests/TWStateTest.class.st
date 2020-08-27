Class {
	#name : #TWStateTest,
	#superclass : #TWRepositoryTest,
	#category : #'TestWorkers-Changes-Tests'
}

{ #category : #'tests - starting transactions - memory' }
TWStateTest >> testCommitInAMemoryCommitCreatesANewMemoryCommit [

	| previous |
	repository createInitialCommit.
	repository startTransaction.
	
	previous := repository currentCommit.
	repository commit.
	
	self deny: repository currentCommit equals: previous
]

{ #category : #'tests - starting transactions - memory' }
TWStateTest >> testCommitInAMemoryCommitKeepsBothTheOldAndNewCommit [

	| previous |
	repository createInitialCommit.
	repository startTransaction.
	
	previous := repository currentCommit.
	repository commit.
	
	self assert: (repository commits includes: previous).
	self assert: (repository commits includes: repository currentCommit)
	
]

{ #category : #'tests - starting transactions - initial' }
TWStateTest >> testCreatingInitialCommitHasNotNilCommitID [

	| initial |
	repository createInitialCommit.
	initial := repository currentCommit.

	self assert: initial commitId isNotNil
]

{ #category : #'tests - starting transactions - initial' }
TWStateTest >> testInitialCommitIncludesInformationAboutTheCurrentImageVersion [

	| initial |
	repository createInitialCommit.
	initial := repository currentCommit.

	self assert: initial imageVersion equals: SystemVersion current
]

{ #category : #'tests - initial state' }
TWStateTest >> testNewRepositoryStartsWithInvalidCommit [

	self assert: repository currentCommit isInvalid
]

{ #category : #'tests - starting transactions - initial' }
TWStateTest >> testStartingANewTransactionInInitialCommitCreatesANewCommitThatIsDifferentThanTheInitial [

	| initial |
	repository createInitialCommit.
	initial := repository currentCommit.
	
	repository startTransaction.
	self deny: repository currentCommit equals: initial
]

{ #category : #'tests - starting transactions - initial' }
TWStateTest >> testStartingANewTransactionInInitialCommitCreatesANewCommitThatIsValid [

	repository createInitialCommit.
	repository startTransaction.
	self deny: repository currentCommit isInvalid 
]

{ #category : #'tests - starting transactions - invalid' }
TWStateTest >> testStartingANewTransactionInInvalidCommitIsNotPossible [

	self deny: repository currentCommit canStartTransaction
]

{ #category : #'tests - starting transactions - invalid' }
TWStateTest >> testStartingANewTransactionInInvalidCommitRaisesErrors [

	self 
		should: [ repository startTransaction ] 
		raise: TWImpossibleToStartTransaction.

]

{ #category : #'tests - starting transactions - memory' }
TWStateTest >> testStartingANewTransactionInMemoryCommitIsNotPossible [

	repository createInitialCommit.
	repository startTransaction.
	
	self deny: repository currentCommit isInvalid 
]

{ #category : #'tests - starting transactions - memory' }
TWStateTest >> testStartingANewTransactionInMemoryCommitRaisesErrors [

	repository createInitialCommit.
	repository startTransaction.
	
	self 
		should: [ repository startTransaction ] 
		raise: TWImpossibleToStartTransaction.

]
