Class {
	#name : #TWWorkerInstance,
	#superclass : #Object,
	#instVars : [
		'path',
		'isRunning'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #'instance creation' }
TWWorkerInstance class >> directory: aPath [ 

	^ self basicNew
		path: aPath;
		yourself.
]

{ #category : #'instance control' }
TWWorkerInstance >> ensureRunning [
	
	self isRunning ifFalse: [ 
	  OSSUnixSubprocess new
		shellCommand: Smalltalk vm fileName , ' --headless ' , self imageName , ' eval --no-quit "TWRunner uniqueInstance start"&';
		workingDirectory: path fullName;
		run ].
	
	isRunning := true.
]

{ #category : #accessing }
TWWorkerInstance >> id [
	
	^ path basename asInteger
]

{ #category : #accessing }
TWWorkerInstance >> imageName [
	
	^ 'worker.image'
]

{ #category : #accessing }
TWWorkerInstance >> isRunning [
	
	^ isRunning ifNil: [ isRunning := false ]
]

{ #category : #accessing }
TWWorkerInstance >> isRunning: aFalse [ 
	isRunning := aFalse
]

{ #category : #accesssing }
TWWorkerInstance >> path: aDiskDirectoryEntry [ 
	path := aDiskDirectoryEntry
]
