Class {
	#name : #TWWatchdog,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'rootDirectory',
		'templatePath',
		'instances'
	],
	#category : #'TestWorkers-Runner'
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

{ #category : #'instance creation' }
TWWatchdog >> createInstance: anId [ 

	| directory |

	directory := rootDirectory / anId asString.
	directory ensureCreateDirectory.
	templatePath copyAllTo: directory.
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

{ #category : #'instance creation' }
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

	instances size >= aNumber ifTrue: [ ^ self ].
	
	1 to: aNumber do: [ :index | 
		(instances anySatisfy: [ :e | e id = index ]) 
			ifFalse: [ self createInstance: index ]].
		
	self readWorkers.
]

{ #category : #initialization }
TWWatchdog >> ensureTemplate [
	
	templatePath exists ifFalse: [ templatePath ensureCreateDirectory ].
	(templatePath / 'worker.image') exists 
		ifTrue: [ ^ self ].

	self downloadAndUnzip.
	self installWorker.
	self deleteDownloadedImage.
]

{ #category : #'instance creation' }
TWWatchdog >> imageUrl [
	^ 'http://files.pharo.org/image/90/latest-64.zip' asUrl
]

{ #category : #accessing }
TWWatchdog >> initialize [

	super initialize.
	templatePath := rootDirectory / 'template'.

	self ensureTemplate.
	self readWorkers.
]

{ #category : #configuration }
TWWatchdog >> inputQueueName [ 

	^ 'watchdog'
]

{ #category : #'instance creation' }
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

{ #category : #'instances control' }
TWWatchdog >> launchInstances [
	
	instances do: [ :anInstance | anInstance ensureRunning ]
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
		sendOn: connection
]
