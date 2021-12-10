Class {
	#name : #TWMultipleTestItem,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'testSelector',
		'tests'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #actions }
TWMultipleTestItem >> drTestsBrowse [
]

{ #category : #actions }
TWMultipleTestItem >> isAbstract [
	
	^ false
]

{ #category : #actions }
TWMultipleTestItem >> name [

	^ ', ' join: (tests collect: [ :test | test key , ' >> ' , test value ])
]

{ #category : #actions }
TWMultipleTestItem >> runTestInClient: client [ 
	
	^ client runMultipleTest: self
]

{ #category : #actions }
TWMultipleTestItem >> tests [

	^ tests
]

{ #category : #actions }
TWMultipleTestItem >> tests: aCollection [

	tests := aCollection
]
