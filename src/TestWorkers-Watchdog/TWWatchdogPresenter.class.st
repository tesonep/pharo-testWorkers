Class {
	#name : #TWWatchdogPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'instanceTable'
	],
	#category : #'TestWorkers-Watchdog-UI'
}

{ #category : #specs }
TWWatchdogPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical 
			add: #instanceTable;
			yourself 
]

{ #category : #initialization }
TWWatchdogPresenter >> initializePresenters [ 

	instanceTable := self newTable.
]

{ #category : #initialization }
TWWatchdogPresenter >> modelChanged [

	instanceTable items: self watchdog instances
]

{ #category : #accessing }
TWWatchdogPresenter >> watchdog [

	^ self model
]
