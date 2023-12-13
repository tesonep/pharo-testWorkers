Class {
	#name : #TWOpenExceptionCommand,
	#superclass : #DTLeafResultCommand,
	#category : #'TestWorkers-UI'
}

{ #category : #default }
TWOpenExceptionCommand class >> defaultName [

	^ 'Open Exception'
]

{ #category : #hooks }
TWOpenExceptionCommand >> canBeExecuted [

	^ self resultSelected isLeaf and: [ self resultSelected content hasException ]
]

{ #category : #hooks }
TWOpenExceptionCommand >> canBeRun [

	^ super canBeRun and: [ self resultSelected content hasException ]
]

{ #category : #executing }
TWOpenExceptionCommand >> execute [

	(TWFailingTestPresenter on: self resultSelected content) open
]
