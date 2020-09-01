Class {
	#name : #TWWatchdog,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'rootDirectory',
		'templatePath',
		'minNumberInstances',
		'instances',
		'pingService'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'as yet unclassified' }
TWWatchdog class >> onRootDirectory: aFileReference [
	
	^ self basicNew
		rootDirectory: aFileReference;
		initialize;
		yourself
]

{ #category : #testing }
TWWatchdog >> canBeInstance: aDiskDirectoryEntry [ 
	
	^ aDiskDirectoryEntry asFileReference basename asInteger isNotNil
]

{ #category : #'instances-control' }
TWWatchdog >> checkDeadInstances [
	
	instances do: [ :anInstance | anInstance checkAlive ].
	self launchInstances.
]

{ #category : #'instances-creation' }
TWWatchdog >> createInstance: anId [ 

	| directory |

	directory := rootDirectory / anId asString.
	directory ensureCreateDirectory.
	templatePath copyAllTo: directory.
]

{ #category : #initialization }
TWWatchdog >> createTemplate [
	
	templatePath exists 
		ifFalse: [ templatePath ensureCreateDirectory ].

	self downloadAndUnzip.
	self installWorker.
	self deleteDownloadedImage.
]

{ #category : #initialization }
TWWatchdog >> deleteDownloadedImage [
	
	| downloadedImages |
	downloadedImages := (templatePath childrenMatching: '*.image') 
		reject: [ :e | e basename = 'worker.image' ].
		
	downloadedImages do: [ :anImage | 
		anImage ensureDelete.
		(anImage withExtension: 'changes') ensureDelete ].
]

{ #category : #'instances-creation' }
TWWatchdog >> downloadAndUnzip [ 

	| zipFile zipArchive |
	zipFile := templatePath / self imageUrl file.
	
	zipFile exists 
		ifFalse: [
			ZnClient new
				url: self imageUrl;
				downloadTo: templatePath ] . 
	
	zipArchive := ZipArchive new readFrom: zipFile.
	
	zipArchive extractAllTo: templatePath overwrite: true.
	zipArchive close.
	
	zipFile ensureDelete.
]

{ #category : #initialization }
TWWatchdog >> ensureInstances: aNumber [

	minNumberInstances := aNumber.
	instances size >= aNumber ifTrue: [ ^ self ].
	
	1 to: aNumber do: [ :index | 
		(instances anySatisfy: [ :e | e id = index ]) 
			ifFalse: [ self createInstance: index ]].
		
	self readWorkers.
]

{ #category : #initialization }
TWWatchdog >> ensureTemplate [

	self hasTemplate ifFalse: [ self createTemplate ]
]

{ #category : #initialization }
TWWatchdog >> hasTemplate [

	^ (templatePath / self templateName ) exists 
		
]

{ #category : #'instances-creation' }
TWWatchdog >> imageUrl [
	^ 'http://files.pharo.org/image/90/latest-64.zip' asUrl
]

{ #category : #initialization }
TWWatchdog >> initialize [

	super initialize.
	templatePath := rootDirectory / 'template'.
	minNumberInstances := 0.
	instances := OrderedCollection new.

	self hasTemplate 
		ifTrue: [ self readWorkers ].
]

{ #category : #configuration }
TWWatchdog >> inputQueueName [ 

	^ 'watchdog'
]

{ #category : #'instances-creation' }
TWWatchdog >> installWorker [

	| downloadedImageName possibleImages |
	
	possibleImages := templatePath childrenMatching: '*.image'.
	self assert: possibleImages size = 1.
	
	downloadedImageName := possibleImages first basename.

	OSSUnixSubprocess new
		command: Smalltalk vm fileName;
		arguments: { '--headless'. downloadedImageName. 'save'. 'worker' };
		workingDirectory: templatePath fullName;
		runAndWaitOnExitDo: [ :process | 
			process isSuccess ifFalse: [ 1halt. ]].

	OSSUnixSubprocess new
		command: Smalltalk vm fileName;
		arguments: { '--headless'. 'worker.image'. 'eval'. '--save'. 'Metacello new
	baseline: ''TestWorkers'';
	repository: ''github://tesonep/pharo-testWorkers'';
	load: ''runner''' };
		workingDirectory: templatePath fullName;
		runAndWaitOnExitDo: [ :process | 
			process isSuccess ifFalse: [ 1halt. ]]		
	
]

{ #category : #'instances-control' }
TWWatchdog >> launchInstances [
	
	instances do: [ :anInstance | anInstance ensureRunning ]
]

{ #category : #accessing }
TWWatchdog >> minNumberInstances [
	^ minNumberInstances
]

{ #category : #accessing }
TWWatchdog >> minNumberInstances: anObject [
	minNumberInstances := anObject
]

{ #category : #configuration }
TWWatchdog >> processName [ 

	^ 'TWWatchdog'
]

{ #category : #initialization }
TWWatchdog >> readWorkers [
	
	| directories |
	directories := rootDirectory entries select: [:e | e isDirectory ].

	instances := directories 
		select: [ :e | self canBeInstance: e ] 
		thenCollect: [ :e | TWWorkerInstance directory: e ].

]

{ #category : #operations }
TWWatchdog >> receivePong: aTWPong [

	instances 
		detect: [ :anInstance | anInstance path fullName = aTWPong path ]
		ifFound: [ :anInstance | anInstance pongReceived ]
		ifNone: [  ].
]

{ #category : #accessing }
TWWatchdog >> rootDirectory [
	^ rootDirectory
]

{ #category : #accessing }
TWWatchdog >> rootDirectory: anObject [
	rootDirectory := anObject
]

{ #category : #operations }
TWWatchdog >> sendPing [
	
	TWPing new
		sendOn: connection.
	self checkDeadInstances.
]

{ #category : #operations }
TWWatchdog >> start [

	super start.
	pingService := TKTParameterizableService new.
	pingService name: 'TWPingService'.
	pingService stepDelay: 1 second.
	pingService step: [ self sendPing ].
	pingService start.
]

{ #category : #operations }
TWWatchdog >> stop [ 
	
	super stop.
	pingService ifNotNil: [ pingService stop ].
]

{ #category : #initialization }
TWWatchdog >> templateName [ 

	^ 'worker.image'
]
