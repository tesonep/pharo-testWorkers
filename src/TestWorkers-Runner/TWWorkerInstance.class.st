Class {
	#name : #TWWorkerInstance,
	#superclass : #Object,
	#instVars : [
		'path',
		'isRunning',
		'lastPong'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #'instance creation' }
TWWorkerInstance class >> directory: aPath [ 

	^ self basicNew
		path: aPath;
		yourself.
]

{ #category : #accessing }
TWWorkerInstance >> checkAlive [

	lastPong ifNil: [ ^ self ].

	(DateAndTime now - lastPong) > 90 seconds 
		ifTrue: [ isRunning := false. ] 
]

{ #category : #'instance control' }
TWWorkerInstance >> ensureRunning [
	
	self isRunning ifFalse: [ 
	  OSSUnixSubprocess new
		shellCommand: Smalltalk vm fileName , ' --headless ' , self imageName , ' eval --no-quit "TWRunner uniqueInstance startWatched"';
		workingDirectory: path fullName;
		run.
		lastPong := DateAndTime now.
		isRunning := true.
	].
	

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
TWWorkerInstance >> initialize [ 

	super initialize.
	lastPong := DateAndTime now.
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
TWWorkerInstance >> path [

	^ path
]

{ #category : #accesssing }
TWWorkerInstance >> path: aDiskDirectoryEntry [ 
	path := aDiskDirectoryEntry
]

{ #category : #accessing }
TWWorkerInstance >> pongReceived [

	lastPong := DateAndTime now
]
