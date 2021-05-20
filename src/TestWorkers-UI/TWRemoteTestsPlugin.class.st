"
I am a DrTestsPlugin. I extend the UI to use the TWClient runner to run the tests.
Once I am in the system the UI of DrTest will discover me and show me in the possible runners.

The most interesting methods I have are: 

 - `runForConfiguration:` : This method sends the test requests to the unique instance of TWClient and register myself to receive the notifications where the TWClient is updated. The important thing is that I shuffle the tests classes before sending. This improves the response time of the global execution. 
 
 - `updateResults` : This message is sent by the TWClient when a received message has update it. I force the DrTest UI to update. Generating a new result tree and updating the status bar
"
Class {
	#name : #TWRemoteTestsPlugin,
	#superclass : #DrTestsPlugin,
	#instVars : [
		'client',
		'startTime',
		'finishCallbackBlock'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #'api - accessing' }
TWRemoteTestsPlugin class >> pluginName [
	
	^ 'Remote Runner'
]

{ #category : #'api - accessing' }
TWRemoteTestsPlugin class >> pluginResultClass [
	
	^ TWRemoteTestsResult
]

{ #category : #'api - accessing' }
TWRemoteTestsPlugin class >> weight [

	^ 7
]

{ #category : #events }
TWRemoteTestsPlugin >> finishCallbackBlock: aBlock [

	finishCallbackBlock := aBlock
]

{ #category : #ui }
TWRemoteTestsPlugin >> pluginPresenterClass [ 

	^ TWPluginPresenter
]

{ #category : #accessing }
TWRemoteTestsPlugin >> pragmaForResultTrees [

	^ #'dtRemoteTestResultTreeNamed:order:'
]

{ #category : #api }
TWRemoteTestsPlugin >> resultButtonHelp [

	^ 'Browse the method selected in the results list.'
]

{ #category : #api }
TWRemoteTestsPlugin >> runForConfiguration: aDTpluginConfiguration [

	| result |
	client := TWClient uniqueInstance.
	client ensureStart.
	client resetResults.
	
	client onUpdate: (WeakMessageSend receiver: self selector: #updateResults).

	client purgePendingMessages.

	(aDTpluginConfiguration items reject: [ :e | e isAbstract ]) shuffle
		do: [ :aClass | client runTestClass: aClass ].

	result := TWRemoteTestsResult new.
	result client: client.
	startTime := DateAndTime now.
	
	^ result
]

{ #category : #api }
TWRemoteTestsPlugin >> startButtonHelp [
	^ 'Run test in selected packages using remote servers'
]

{ #category : #api }
TWRemoteTestsPlugin >> startButtonLabel [
	^ 'Run Remote'
]

{ #category : #events }
TWRemoteTestsPlugin >> updateResults [
	
	| result |
	
	result := TWRemoteTestsResult new.
	result client: client.
	
	client requests isEmpty 
		ifTrue: [ | duration |
			duration := DateAndTime now - startTime. 
			self announceStatusChanged: 'Finished: ' , duration printString ]
		ifFalse: [ self announceStatusChanged: 'Running tests...' ].

	self announceResultsChanged: result.

	client requests ifEmpty: [
		finishCallbackBlock ifNotNil: [ finishCallbackBlock value: self] ]
]
