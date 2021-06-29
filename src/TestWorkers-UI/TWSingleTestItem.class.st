Class {
	#name : #TWSingleTestItem,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'testSelector'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #operations }
TWSingleTestItem >> drTestsBrowse [
	
	Smalltalk tools browser openOnClass: testClass selector: testSelector 
]

{ #category : #testing }
TWSingleTestItem >> isAbstract [
	
	^ false
]

{ #category : #accessing }
TWSingleTestItem >> name [

	^ testClass name asString , ' >> ' , testSelector asString
]

{ #category : #operation }
TWSingleTestItem >> runTestInClient: client [ 
	
	^ client runSingleTest: self
	
]

{ #category : #accessing }
TWSingleTestItem >> testClass [

	^ testClass
]

{ #category : #accessing }
TWSingleTestItem >> testClass: anObject [

	testClass := anObject
]

{ #category : #accessing }
TWSingleTestItem >> testSelector [

	^ testSelector
]

{ #category : #accessing }
TWSingleTestItem >> testSelector: anObject [

	testSelector := anObject
]

{ #category : #accessing }
TWSingleTestItem >> testSelectors [ 

	^ #()
]
