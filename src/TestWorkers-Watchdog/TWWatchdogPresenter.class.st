Class {
	#name : #TWWatchdogPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'instanceTable',
		'startInstancesButton',
		'stopInstancesButton'
	],
	#category : #'TestWorkers-Watchdog-UI'
}

{ #category : #specs }
TWWatchdogPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical 
			add: #instanceTable;
			add: (SpBoxLayout newHorizontal
						add: #startInstancesButton;
						add: #stopInstancesButton;
						yourself) withConstraints: [:cs | cs padding: 2; height: 25 ];
			yourself 
]

{ #category : #initialization }
TWWatchdogPresenter >> initializePresenters [ 

	instanceTable := self newTable.

	instanceTable
		addColumn: (SpStringTableColumn title: 'Number' evaluated: [:e | e path basename]);
		addColumn: (SpStringTableColumn title: 'ID' evaluated: #instanceId);
		addColumn: (SpStringTableColumn title: 'Host' evaluated: #host);
		addColumn: (SpStringTableColumn title: 'State' evaluated: [:e | e state stateName]);
		addColumn: (SpStringTableColumn title: 'Last Pong' evaluated: [:e | 
			e timeSinceLastPong ifNotNil: [ :aDuration | (aDuration roundTo: 1 second) humanReadablePrintString ]]);		
		beResizable.

	startInstancesButton := self newButton
		label: 'Start Instances';
		action: [ self watchdog startInstances ]
		yourself.
		
	stopInstancesButton := self newButton
		label: 'Stop Instances';
		action: [ self watchdog stopInstances ]
		yourself	
]

{ #category : #initialization }
TWWatchdogPresenter >> initializeWindow: aWindow [

	super initializeWindow: aWindow.

	aWindow extent: 800@500.
	aWindow announcer when: SpWindowWillClose send: #stop to: self.
]

{ #category : #initialization }
TWWatchdogPresenter >> modelChanged [

	| originalSelection |
	originalSelection := 	instanceTable selection selectedItem.
	instanceTable items: self watchdog instances.
	instanceTable selectItem: originalSelection.

	self watchdog onChange: [ self updatePresenter ]
]

{ #category : #initialization }
TWWatchdogPresenter >> stop [ 

	SpNotification dispatchInfoTo: self application message: 'Watchdog stopped'. 
	self watchdog stop
]

{ #category : #accessing }
TWWatchdogPresenter >> watchdog [

	^ self model
]
