Class {
	#name : #TWWorkerInstance,
	#superclass : #Object,
	#instVars : [
		'path',
		'state',
		'lastPong',
		'instanceId',
		'watchdog',
		'pid',
		'host'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'instance creation' }
TWWorkerInstance class >> directory: aPath on: aWatchdog [

	^ self basicNew
		path: aPath;
		watchdog: aWatchdog;
		initialize;
		yourself.
]

{ #category : #'private - operations' }
TWWorkerInstance >> doStart [

	  state := TWStartingInstance on: self.

	  OSSUnixSubprocess new
		shellCommand: Smalltalk vm fileName , ' --headless ' , self imageName , ' eval --no-quit "TWRunner uniqueInstance startWatched"';
		workingDirectory: path fullName;
		run.
		

]

{ #category : #'instance control' }
TWWorkerInstance >> ensureMaterialized [

	state ensureMaterialized
]

{ #category : #'instance control' }
TWWorkerInstance >> ensureRunning [
	
	state ensureRunning
]

{ #category : #'instance control' }
TWWorkerInstance >> heartbeat [
	state heartbeat
]

{ #category : #accessing }
TWWorkerInstance >> host [
	^ host
]

{ #category : #accessing }
TWWorkerInstance >> host: anObject [
	host := anObject
]

{ #category : #accessing }
TWWorkerInstance >> imageName [
	
	^ 'worker.image' 
]

{ #category : #accessing }
TWWorkerInstance >> imagePath [
	
	^ path / self imageName 
]

{ #category : #accessing }
TWWorkerInstance >> initialize [ 

	super initialize.
	
	state := TWNonExistingInstance on: self.
	state checkState.
]

{ #category : #accessing }
TWWorkerInstance >> instanceId [ 

	^ instanceId 
]

{ #category : #accessing }
TWWorkerInstance >> instanceId: anUUID [ 
	instanceId := anUUID
]

{ #category : #accessing }
TWWorkerInstance >> isRunning [
	
	^ state isRunning
]

{ #category : #operations }
TWWorkerInstance >> killed: aTWKilled [ 
	
	state killed: aTWKilled
]

{ #category : #'private - operations' }
TWWorkerInstance >> materialize [
	
	path ensureCreateDirectory.
	watchdog templatePath copyAllTo: path.
	
	state checkState.
]

{ #category : #accessing }
TWWorkerInstance >> path [

	^ path
]

{ #category : #accessing }
TWWorkerInstance >> path: aDiskDirectoryEntry [ 
	path := aDiskDirectoryEntry
]

{ #category : #accessing }
TWWorkerInstance >> pid: anInteger [

	pid := anInteger
]

{ #category : #'instance control' }
TWWorkerInstance >> pongReceived: aTWPong [

	state pongReceived: aTWPong
]

{ #category : #'instance control' }
TWWorkerInstance >> printOn: aStream [

	aStream 
		print: self class name;
		space;
		nextPut: $(;
		print: instanceId;
		space;
		nextPutAll: path basename;
		space;
		print: state;
		nextPut: $).
		
]

{ #category : #'instance control' }
TWWorkerInstance >> start [

	self ensureRunning
]

{ #category : #accessing }
TWWorkerInstance >> state [
	^ state
]

{ #category : #'private - accessing' }
TWWorkerInstance >> state: aNewState [

	state := aNewState
]

{ #category : #accessing }
TWWorkerInstance >> timeSinceLastPong [

	lastPong := state lastPong.
	lastPong ifNil: [ ^ nil ].
	
	^ DateAndTime now - state lastPong
]

{ #category : #accessing }
TWWorkerInstance >> watchdog: aTWWatchdog [ 
	watchdog := aTWWatchdog
]
