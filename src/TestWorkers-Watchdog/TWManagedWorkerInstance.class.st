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

	| startScript |
	state := TWStartingInstance on: self.

	startScript := '
			TWAbstractConnected 
				serverHost: ''{1}'';
				username: ''{2}'';
				password: ''{3}''.
			TWRunner uniqueInstance startWatched.' format: { 
			               TWAbstractConnected serverHost.
			               TWAbstractConnected username.
			               TWAbstractConnected password }.

	TWSubprocessWrapper
		runWithoutWaitingShellCommand:
			Smalltalk vm fileName ,' ', "' --headless ' ," self imageName
			, ' eval --no-quit "' , startScript , '"'
		workingDirectory: path fullName 
]

{ #category : #'instance control' }
TWManagedWorkerInstance >> ensureMaterialized [

	state ensureMaterialized
]

{ #category : #'instance control' }
TWManagedWorkerInstance >> ensureRunning [
	
	state ensureRunning
]

{ #category : #testing }
TWManagedWorkerInstance >> hasAlreadyRegistredToWatchdogWithId: anId [

	^ watchdog hasAnInstanceRegistredWithId: anId
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
	
	^ watchdog templateName
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
	path = watchdog templatePath ifFalse: [ 
		watchdog templatePath copyAllTo: path ].

	state checkState
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
