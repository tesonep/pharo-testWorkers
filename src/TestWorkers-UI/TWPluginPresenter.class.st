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
