Class {
	#name : #TWWatchdogPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'instanceTable',
		'startInstancesButton',
		'stopInstancesButton',
		'updateProcess'
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
						yourself) withConstraints: [:cs | cs padding: 2; height: 35 ];
			yourself 
]

{ #category : #initialization }
TWWatchdogPresenter >> contextMenu [

	| hasSelection |

	hasSelection := instanceTable selection selectedItem notNil.

	^ SpMenuPresenter new 
		addGroup: [ :group | group 
			addItem: [ :item | item 
				name: 'Stop Instance';
				icon: (self iconNamed: #delete);
				enabled: hasSelection;
				action: [ self stopSelectedInstance ] ];
			addItem: [ :item | item 
				name: 'Start Instance';
				icon: (self iconNamed: #smallDoIt);
				enabled: hasSelection;
				action: [ self startSelectedInstance ] ] ].
]

{ #category : #initialization }
TWWatchdogPresenter >> initializePresenters [ 

	instanceTable := self newTable.

	instanceTable
		addColumn: (SpStringTableColumn title: 'Number' evaluated: [:e | e path basename]);
		addColumn: (SpStringTableColumn title: 'ID' evaluated: #instanceId);
		addColumn: (SpStringTableColumn title: 'Host' evaluated: #host);
		addColumn: (SpStringTableColumn title: 'State' evaluated: [:e | e state stateName]);
		addColumn: (SpStringTableColumn title: 'Test' evaluated: [:e | e state test]);
		addColumn: (SpStringTableColumn title: 'Last Pong' evaluated: [:e | 
			e timeSinceLastPong ifNotNil: [ :aDuration | (aDuration roundTo: 1 second) humanReadablePrintString ]]);
		contextMenu: [ self contextMenu ];
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
	aWindow title: 'Distributed Runner Instances'.
	aWindow announcer when: SpWindowWillClose send: #stop to: self.
]

{ #category : #initialization }
TWWatchdogPresenter >> modelChanged [

	| originalSelection |
	originalSelection := 	instanceTable selection selectedItem.
	instanceTable items: self watchdog instances.
	instanceTable selectItem: originalSelection.
	
	updateProcess ifNil: [ 
		updateProcess := [ [ true ] whileTrue: [ 1 seconds wait. self updatePresenter. ] ] fork ].
	
]

{ #category : #actions }
TWWatchdogPresenter >> startSelectedInstance [
	
	self watchdog startInstance: instanceTable selectedItem.
]

{ #category : #initialization }
TWWatchdogPresenter >> stop [ 

	SpNotification dispatchInfoTo: self application message: 'Watchdog stopped'. 

	updateProcess ifNotNil: [ updateProcess terminate ].
	self watchdog stop
]

{ #category : #actions }
TWWatchdogPresenter >> stopSelectedInstance [
	
	self watchdog stopInstance: instanceTable selection selectedItem.
]

{ #category : #accessing }
TWWatchdogPresenter >> watchdog [

	^ self model
]
