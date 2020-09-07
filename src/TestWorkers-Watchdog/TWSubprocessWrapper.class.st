Class {
	#name : #TWSubprocessWrapper,
	#superclass : #Object,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'as yet unclassified' }
TWSubprocessWrapper class >> current [

	^ Smalltalk platform isWindows
		ifTrue: [ TWWindowsSubprocessWrapper ]
		ifFalse: [ TWUnixSubprocessWrapper ]
]

{ #category : #'as yet unclassified' }
TWSubprocessWrapper class >> runCommand: command arguments: arguments workingDirectory: workingDirectory [

	^ self current
		  runCommand: command
		  arguments: arguments
		  workingDirectory: workingDirectory
]

{ #category : #'as yet unclassified' }
TWSubprocessWrapper class >> runWithoutWaitingShellCommand: command workingDirectory: workingDirectory [

	^ self current
		  runWithoutWaitingShellCommand: command
		  workingDirectory: workingDirectory
]
