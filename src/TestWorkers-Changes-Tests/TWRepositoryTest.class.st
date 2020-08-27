Class {
	#name : #TWRepositoryTest,
	#superclass : #TWAbstractTest,
	#instVars : [
		'repository'
	],
	#category : #'TestWorkers-Changes-Tests'
}

{ #category : #running }
TWRepositoryTest >> setUp [

	super setUp.
	repository := TWRepository new.
]

{ #category : #running }
TWRepositoryTest >> tearDown [ 

	repository close.
	super tearDown.
]
