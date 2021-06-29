Class {
	#name : #TWPluginPresenter,
	#superclass : #DTDefaultPluginPresenter,
	#category : #'TestWorkers-UI'
}

{ #category : #'private - commands' }
TWPluginPresenter class >> buildResultGroupWith: presenterInstance [

	| commandGroup pluginCommands |
	commandGroup := (CmCommandGroup named: 'Results tools') asSpecGroup
		description: 'Commands related to result.';
		register: (DTResultBrowseCommand forSpec context: presenterInstance) beHiddenWhenCantBeRun;
		register: (TWOpenExceptionCommand forSpec context: presenterInstance) beHiddenWhenCantBeRun;
		yourself.
	pluginCommands := presenterInstance plugin
		buildContextualMenuGroupWith: presenterInstance.
	pluginCommands entries ifEmpty: [ ^ commandGroup ].
	^ commandGroup
		register: pluginCommands beDisplayedAsGroup;
		yourself
]

{ #category : #'private - initialization' }
TWPluginPresenter >> initializeItemsListAndLabel [

	itemsList := self instantiate: TWFilterableTreePresenter.
	itemsList
		help: 'Select the classes to analyze. Cmd+A or Ctrl+A to select all classes.';
		displayBlock: [ :item | item name ];
		childrenBlock: [ :item | item testSelectors collect: [ :e | TWSingleTestItem new
				testSelector: e;
				testClass: item;
				yourself ] ]; 
		whenSelectionChangedDo: [ self whenItemsSelectionChanged: self selectedItems ];
		beMultipleSelection;
		contextMenu: [ (self rootCommandsGroup / 'List items menu') beRoot asMenuPresenter ].
	packagesList
		whenSelectionChangedDo: [ self whenPackagesSelectionChanged: self packagesSelected ]
]
