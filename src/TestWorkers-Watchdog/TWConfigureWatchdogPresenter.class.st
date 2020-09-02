Class {
	#name : #TWConfigureWatchdogPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'rootDirectoryInput',
		'creationStrategyDropList',
		'nbrInstancesInput',
		'startButton'
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
TWConfigureWatchdogPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical 
		add: (SpGridLayout new
					beRowHomogeneous;
					add: 'Root Directory'				at: 1@1;
					add: #rootDirectoryInput 		at: 2@1 span: 2@1;
					add: 'Creation Strategy'			at: 1@2;		
					add: #creationStrategyDropList	at: 2@2 span: 2@1;
					add: 'Number of instances'		at: 1@3;
					add: #nbrInstancesInput			at: 2@3 span: 2@1;
					yourself);
		add: #startButton withConstraints: [ :cs | cs padding: 5; height: 30 ];
		yourself.
							
						
										
					

]

{ #category : #specs }
TWConfigureWatchdogPresenter class >> defaultStrategyClass [

	^ defaultStrategyClass ifNil: [ defaultStrategyClass := TWCurrentPharoCommitCreationStrategy ]
]

{ #category : #initialization }
TWConfigureWatchdogPresenter >> connectPresenters [

"	rootDirectoryInput."
	creationStrategyDropList items: TWCreationStrategy allSubclasses.
	creationStrategyDropList selectItem: self class defaultStrategyClass.
	
	nbrInstancesInput minimum: 1.
	nbrInstancesInput number: self class defaultInstanceSize.
"	startButton"
]

{ #category : #initialization }
TWConfigureWatchdogPresenter >> initializePresenters [

	rootDirectoryInput := self newTextInput.
	creationStrategyDropList := self newDropList.
	nbrInstancesInput := self newNumberInput.
	startButton := self newButton
]

{ #category : #initialization }
TWConfigureWatchdogPresenter >> initializeWindow: aWindow [

	aWindow initialExtent: 500@200.
	aWindow title: 'Start Instances and Watchdog'
]
