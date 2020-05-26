Class {
	#name : #TWStateTest,
	#superclass : #TWRepositoryTest,
	#category : #'TestWorkers-Tests'
}

{ #category : #'tests - initial state' }
TWStateTest >> testNewRepositoryStartsWithInvalidCommit [

	self assert: repository currentCommit isInvalid
]

{ #category : #'tests - starting transactions - invalid' }
TWStateTest >> testStartingANewTransactionInInvalidCommitCreatesANewCommitThatIsDifferentThanTheInitial [

	| initial |
	initial := repository currentCommit.
	
	repository startTransaction.
	self deny: repository currentCommit equals: initial
]

{ #category : #'tests - starting transactions - invalid' }
TWStateTest >> testStartingANewTransactionInInvalidCommitCreatesANewCommitThatIsValid [

	repository startTransaction.
	self deny: repository currentCommit isInvalid 
]

{ #category : #'tests - starting transactions - invalid' }
TWStateTest >> testStartingANewTransactionInInvalidCommitIsPossible [

	self assert: repository currentCommit canStartTransaction
]

{ #category : #'tests - starting transactions - memory' }
TWStateTest >> testStartingANewTransactionInMemoryCommitIsNotPossible [

	repository startTransaction.
	
	self deny: repository currentCommit isInvalid 
]

{ #category : #'tests - starting transactions - memory' }
TWStateTest >> testStartingANewTransactionInMemoryCommitRaisesErrors [

	repository startTransaction.
	
	self 
		should: [ repository startTransaction ] 
		raise: TWImpossibleToStartTransaction.

]
