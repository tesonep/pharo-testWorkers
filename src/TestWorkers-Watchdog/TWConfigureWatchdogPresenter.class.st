Class {
	#name : #TWConfigureWatchdogPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'rootDirectoryInput',
		'creationStrategyDropList',
		'nbrInstancesInput',
		'startButton',
		'defaultOriginalImageZipInput'
	],
	#classInstVars : [
		'defaultRootDirectory',
		'defaultInstanceSize',
		'defaultStrategyClass'
	],
	#category : #'TestWorkers-Watchdog-UI'
}

{ #category : #specs }
TWConfigureWatchdogPresenter class >> defaultInstanceSize [

	^ defaultInstanceSize ifNil: [ defaultInstanceSize := 3 ]
]

{ #category : #specs }
TWConfigureWatchdogPresenter class >> defaultRootDirectory [

	^ defaultRootDirectory ifNil: [ defaultRootDirectory := FileLocator workingDirectory / 'runners' ].
]

{ #category : #specs }
TWConfigureWatchdogPresenter class >> defaultRootDirectory: aFileReference [

	defaultRootDirectory := aFileReference
]

{ #category : #specs }
TWConfigureWatchdogPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical 
		add: (SpGridLayout new
					beRowHomogeneous;
					add: 'Root Directory'						at: 1@1;
					add: #rootDirectoryInput 				at: 2@1 span: 2@1;
					add: 'Creation Strategy'					at: 1@2;		
					add: #creationStrategyDropList			at: 2@2 span: 2@1;
					add: 'Original Zip File'					at: 1@3;		
					add: #defaultOriginalImageZipInput	at: 2@3 span: 2@1;
					add: 'Number of instances'				at: 1@4;
					add: #nbrInstancesInput					at: 2@4 span: 2@1;
					yourself);
		add: #startButton withConstraints: [ :cs | cs padding: 5; height: 50 ];
		yourself.
							
						
										
					

]

{ #category : #specs }
TWConfigureWatchdogPresenter class >> defaultStrategyClass [

	^ defaultStrategyClass ifNil: [ defaultStrategyClass := TWCurrentPharoCommitCreationStrategy ]
]

{ #category : #'world menu' }
TWConfigureWatchdogPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	
	(aBuilder item: #'Start Worker Instances')
		parent: #Tools;
		action: [ self new openWithSpec ];
		order: 18;
		help: 'Let you start a new watchdog and a set of Worker instances';
		icon: self taskbarIcon.

]

{ #category : #initialization }
TWConfigureWatchdogPresenter >> connectPresenters [

	rootDirectoryInput text: self class defaultRootDirectory fullName.
	
	creationStrategyDropList items: TWCreationStrategy allSubclasses.
	creationStrategyDropList selectItem: self class defaultStrategyClass.
	creationStrategyDropList whenSelectedItemChangedDo: [ self updateTextInputs ].
	
	nbrInstancesInput minimum: 1.
	nbrInstancesInput number: self class defaultInstanceSize.
	
	startButton label: 'Start Watchdog'.
	startButton action: [ self start ].
	
	defaultOriginalImageZipInput text: TWCopyImageCreationStrategy defaultOriginalImageZip fullName.
	
	self updateTextInputs.
]

{ #category : #initialization }
TWConfigureWatchdogPresenter >> initializePresenters [

	rootDirectoryInput := self newTextInput.
	creationStrategyDropList := self newDropList.
	nbrInstancesInput := self newNumberInput.
	startButton := self newButton.
	defaultOriginalImageZipInput := self newTextInput.	
	
	creationStrategyDropList display: [ :anStrategyClass | anStrategyClass description ]
]

{ #category : #initialization }
TWConfigureWatchdogPresenter >> initializeWindow: aWindow [

	aWindow initialExtent: 500@300.
	aWindow title: 'Start Instances and Watchdog'
]

{ #category : #actions }
TWConfigureWatchdogPresenter >> start [
	
	| watchdog |
	
	creationStrategyDropList selectedItem = TWCopyImageCreationStrategy 
		ifTrue: [ TWCopyImageCreationStrategy defaultOriginalImageZip: defaultOriginalImageZipInput text asFileReference ].
	
	watchdog := TWWatchdog new
		rootDirectory: rootDirectoryInput text asFileReference;
		useCreationStrategy: creationStrategyDropList selectedItem;
		numberOfInstances: nbrInstancesInput number;
		yourself.
		
	watchdog start.
	
	(TWWatchdogPresenter on: watchdog)
		openWithSpec.
		
	self window close.

]

{ #category : #actions }
TWConfigureWatchdogPresenter >> updateTextInputs [

	 defaultOriginalImageZipInput enabled: creationStrategyDropList selectedItem = TWCopyImageCreationStrategy.
]
