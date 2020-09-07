Class {
	#name : #TWUnixSubprocessWrapper,
	#superclass : #TWSubprocessWrapper,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'as yet unclassified' }
TWUnixSubprocessWrapper class >> runCommand: command arguments: arguments workingDirectory: workingDirectory [

	(Smalltalk at: #OSSUnixSubprocess) new
		command: command;
		arguments: arguments;
		workingDirectory: workingDirectory;
		runAndWaitOnExitDo: [ :process | 
			process isSuccess ifFalse: [ 1halt. ]].
]

{ #category : #'as yet unclassified' }
TWUnixSubprocessWrapper class >> runWithoutWaitingShellCommand: command workingDirectory: workingDirectory [

	  (Smalltalk at: #OSSUnixSubprocess) new
		shellCommand: command;
		workingDirectory: workingDirectory;
		run.
]
