Class {
	#name : #TWRemoteTestsPluginForLifeware,
	#superclass : #TWRemoteTests,
	#instVars : [
		'finishCallbackBlock'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #events }
TWRemoteTestsPluginForLifeware >> finishCallbackBlock: aBlock [

	finishCallbackBlock := aBlock
]

{ #category : #events }
TWRemoteTestsPluginForLifeware >> updateResults [

	super updateResults.
	client requests ifEmpty: [(finishCallbackBlock value: self)]
]
