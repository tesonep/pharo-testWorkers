Class {
	#name : #TWClassRemoved,
	#superclass : #TWAbstractChange,
	#category : #'TestWorkers-Changes-Changes'
}

{ #category : #accessing }
TWClassRemoved >> fromAnnouncement: aClassRemoved [
	| classRemoved |

	classRemoved := aClassRemoved classRemoved.
	className := classRemoved originalName.

	"Fix the name in the definition"
	definition := classRemoved definition
		copyReplaceAll: classRemoved name printString
		with: className printString.

	"Fix the category name in the definition"
	definition := definition
		copyReplaceAll: 'package: ' , 'Unclassified' printString
		with: 'package: ' , aClassRemoved categoryName asString printString
]

{ #category : #accessing }
TWClassRemoved >> oldDefinition [
	
	^ definition
]
