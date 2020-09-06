Class {
	#name : #TWManagedWorkerInstance,
	#superclass : #Object,
	#instVars : [
		'path',
		'state',
		'lastPong',
		'instanceId',
		'watchdog',
		'pid',
		'host',
		'directQueue'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'instance creation' }
TWManagedWorkerInstance class >> directory: aPath on: aWatchdog [

	^ self basicNew
		path: aPath;
		watchdog: aWatchdog;
		initialize;
		yourself.
]

{ #category : #accessing }
TWManagedWorkerInstance >> directQueue [
	^ directQueue
]

{ #category : #accessing }
TWManagedWorkerInstance >> directQueue: anObject [
	directQueue := anObject
]

{ #category : #'private - operations' }
TWManagedWorkerInstance >> doStart [

	  state := TWStartingInstance on: self.

	  OSSUnixSubprocess new
		shellCommand: Smalltalk vm fileName , ' --headless ' , self imageName , ' eval --no-quit "TWRunner uniqueInstance startWatched"';
		workingDirectory: path fullName;
		run.
		

]

{ #category : #'instance control' }
TWManagedWorkerInstance >> ensureMaterialized [

	state ensureMaterialized
]

{ #category : #'instance control' }
TWManagedWorkerInstance >> ensureRunning [
	
	state ensureRunning
]

{ #category : #'instance control' }
TWManagedWorkerInstance >> heartbeat [
	state heartbeat
]

{ #category : #accessing }
TWManagedWorkerInstance >> host [
	^ host
]

{ #category : #accessing }
TWManagedWorkerInstance >> host: anObject [
	host := anObject
]

{ #category : #accessing }
TWManagedWorkerInstance >> imageName [
	
	^ 'worker.image' 
]

{ #category : #accessing }
TWManagedWorkerInstance >> imagePath [
	
	^ path / self imageName 
]

{ #category : #accessing }
TWManagedWorkerInstance >> initialize [ 

	super initialize.
	
	state := TWNonExistingInstance on: self.
	state checkState.
]

{ #category : #accessing }
TWManagedWorkerInstance >> instanceId [ 

	^ instanceId 
]

{ #category : #accessing }
TWManagedWorkerInstance >> instanceId: anUUID [ 
	instanceId := anUUID
]

{ #category : #accessing }
TWManagedWorkerInstance >> isRunning [
	
	^ state isRunning
]

{ #category : #operations }
TWManagedWorkerInstance >> killed: aTWKilled [ 
	
	state killed: aTWKilled
]

{ #category : #'private - operations' }
TWManagedWorkerInstance >> materialize [
	
	path ensureCreateDirectory.
	watchdog templatePath copyAllTo: path.
	
	state checkState.
]

{ #category : #accessing }
TWManagedWorkerInstance >> path [

	^ path
]

{ #category : #accessing }
TWManagedWorkerInstance >> path: aDiskDirectoryEntry [ 
	path := aDiskDirectoryEntry
]

{ #category : #accessing }
TWManagedWorkerInstance >> pid: anInteger [

	pid := anInteger
]

{ #category : #'instance control' }
TWManagedWorkerInstance >> pongReceived: aTWPong [

	state pongReceived: aTWPong
]

{ #category : #'instance control' }
TWManagedWorkerInstance >> printOn: aStream [

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
TWManagedWorkerInstance >> start [

	self ensureRunning
]

{ #category : #accessing }
TWManagedWorkerInstance >> state [
	^ state
]

{ #category : #'private - accessing' }
TWManagedWorkerInstance >> state: aNewState [

	state := aNewState
]

{ #category : #accessing }
TWManagedWorkerInstance >> timeSinceLastPong [

	lastPong := state lastPong.
	lastPong ifNil: [ ^ nil ].
	
	^ DateAndTime now - state lastPong
]

{ #category : #accessing }
TWManagedWorkerInstance >> watchdog: aTWWatchdog [ 
	watchdog := aTWWatchdog
]
