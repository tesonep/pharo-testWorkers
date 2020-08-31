Class {
	#name : #TWRemoteTests,
	#superclass : #DrTestsPlugin,
	#instVars : [
		'client',
		'drTestUI',
		'startTime'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #'api - accessing' }
TWRemoteTests class >> pluginName [
	
	^ 'Remote Runner'
]

{ #category : #'api - accessing' }
TWRemoteTests class >> pluginResultClass [
	
	^ TWRemoteTestsResult
]

{ #category : #'api - accessing' }
TWRemoteTests class >> weight [

	^ 7
]

{ #category : #api }
TWRemoteTests >> configureUI: anUI [

	drTestUI := anUI.
	^ super configureUI: anUI.

]

{ #category : #accessing }
TWRemoteTests >> pragmaForResultTrees [

	^ #'dtRemoteTestResultTreeNamed:order:'
]

{ #category : #api }
TWRemoteTests >> resultButtonHelp [

	^ 'Browse the method selected in the results list.'
]

{ #category : #api }
TWRemoteTests >> runForConfiguration: aDTpluginConfiguration [

	| result |
	client := TWClient uniqueInstance.
	client ensureStart.
	client resetResults.
	
	client onUpdate: (WeakMessageSend receiver: self selector: #updateResults).

	(aDTpluginConfiguration items reject: [ :e | e isAbstract ]) 
		do: [ :aClass | client runTestClass: aClass ].

	result := TWRemoteTestsResult new.
	result client: client.
	startTime := DateAndTime now.
	
	^ result
]

{ #category : #api }
TWRemoteTests >> startButtonHelp [
	^ 'Run test in selected packages using remote servers'
]

{ #category : #api }
TWRemoteTests >> startButtonLabel [
	^ 'Run Remote'
]

{ #category : #events }
TWRemoteTests >> updateResults [
	
	| result |
	
	result := TWRemoteTestsResult new.
	result client: client.
	
	client requests size = 0 
		ifTrue: [ | duration |
			duration := DateAndTime now - startTime. 
			drTestUI updateStatus: 'Finished: ' , duration printString ]
		ifFalse: [ drTestUI updateStatus: 'Running tests...' ].
	drTestUI updateWithPluginResult: result
]
