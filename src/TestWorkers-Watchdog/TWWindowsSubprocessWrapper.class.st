Class {
	#name : #TWWindowsSubprocessWrapper,
	#superclass : #TWSubprocessWrapper,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'as yet unclassified' }
TWWindowsSubprocessWrapper class >> runCommand: command arguments: arguments workingDirectory: workingDirectory [

	| fullCommand |
	
	fullCommand := command , ' ' , (arguments joinUsing: ' ').

	((Smalltalk at: #OSWSWinProcess) new
		shellCommand: fullCommand;
		workingDirectory: workingDirectory;
		runAndWait;
		isSuccess) ifFalse: [ self halt ].

]

{ #category : #'as yet unclassified' }
TWWindowsSubprocessWrapper class >> runWithoutWaitingShellCommand: command workingDirectory: workingDirectory [

	(Smalltalk at: #OSWSWinProcess) new
		shellCommand: command;
		workingDirectory: workingDirectory;
		runUnwatch.
]
