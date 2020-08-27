Class {
	#name : #TWAbstractTest,
	#superclass : #TestCase,
	#instVars : [
		'createdClasses'
	],
	#category : #'TestWorkers-Changes-Tests'
}

{ #category : #'instance creation' }
TWAbstractTest >> newClass: aName [ 
	^self newClass: aName with: #() uses: #()
]

{ #category : #'instance creation' }
TWAbstractTest >> newClass: aName superclass: aSuperclass with: slots uses: aComposition [

	^ self
		newClass: aName
		superclass: aSuperclass
		with: slots
		uses: aComposition
		category: self class category
]

{ #category : #'instance creation' }
TWAbstractTest >> newClass: aName superclass: aSuperclass with: slots uses: aComposition category: category [
	| class |
	class := aSuperclass subclass: aName uses: aComposition slots: slots classVariables: #() poolDictionaries: '' category: category. 
	createdClasses add:class.
	
	^class.
]

{ #category : #'instance creation' }
TWAbstractTest >> newClass: aName with: slots uses: aComposition [
	^ self newClass: aName superclass: Object with: slots uses: aComposition
]

{ #category : #'instance creation' }
TWAbstractTest >> newTrait: aName with: slots [
	^ self newTrait: aName with: slots uses: {}
]

{ #category : #'instance creation' }
TWAbstractTest >> newTrait: aName with: slots uses: aComposition [
	^ self newTrait: aName with: slots uses: aComposition category: 'TraitsV2-Tests-TestClasses'
]

{ #category : #'instance creation' }
TWAbstractTest >> newTrait: aName with: slots uses: aComposition category: category [
	| class |
	class := Trait named: aName uses: aComposition slots: slots package: category  env: self class environment. 
	createdClasses add:class.
	
	^class.
]

{ #category : #running }
TWAbstractTest >> setUp [
	super setUp.
	createdClasses := OrderedCollection new.
]

{ #category : #running }
TWAbstractTest >> tearDown [
	createdClasses reverseDo: #removeFromSystem.
	createdClasses := nil.

	super tearDown
]
