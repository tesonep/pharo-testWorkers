Class {
	#name : #TWCreationStrategy,
	#superclass : #Object,
	#instVars : [
		'watchdog'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWCreationStrategy class >> description [

	^ self subclassResponsibility 
]

{ #category : #initialization }
TWCreationStrategy >> createTemplate [ 

	self templatePath exists 
		ifFalse: [ self templatePath ensureCreateDirectory ].

	self downloadAndUnzip.
	self installWorker.
	self deleteDownloadedImage.
]

{ #category : #initialization }
TWCreationStrategy >> deleteDownloadedImage [
	
	| downloadedImages |
	downloadedImages := (self templatePath childrenMatching: '*.image') 
		reject: [ :e | e basename = 'worker.image' ].
		
	downloadedImages do: [ :anImage | 
		anImage ensureDelete.
		(anImage withExtension: 'changes') ensureDelete ].
]

{ #category : #'instances-creation' }
TWCreationStrategy >> downloadAndUnzip [ 

	| zipFile zipArchive |
	zipFile := self templatePath / self imageUrl file.
	
	zipFile exists 
		ifFalse: [
			ZnClient new
				url: self imageUrl;
				downloadTo: self templatePath ] . 
	
	zipArchive := ZipArchive new readFrom: zipFile.
	
	zipArchive extractAllTo: self templatePath overwrite: true.
	zipArchive close.
	
	zipFile ensureDelete.
]

{ #category : #accessing }
TWCreationStrategy >> imageUrl [ 

	^ self subclassResponsibility
]

{ #category : #'instances-creation' }
TWCreationStrategy >> installWorker [

	| downloadedImageName possibleImages |
	
	possibleImages := self templatePath childrenMatching: '*.image'.
	self assert: possibleImages size = 1.
	
	downloadedImageName := possibleImages first basename.

	TWSubprocessWrapper 
		runCommand: Smalltalk vm fileName
		arguments: { '--headless'. downloadedImageName. 'save'. 'worker' }
		workingDirectory: self templatePath fullName.

	TWSubprocessWrapper 
		runCommand: Smalltalk vm fileName
		arguments: { '--headless'. 'worker.image'. 'eval'. '--save'. 'Metacello new
	baseline: ''TestWorkers'';
	repository: ''github://tesonep/pharo-testWorkers'';
	load: ''worker''' }
		workingDirectory: self templatePath fullName.
]

{ #category : #accessing }
TWCreationStrategy >> templateName [

	^ 'worker.image'
]

{ #category : #accessing }
TWCreationStrategy >> templatePath [ 

	^ watchdog templatePath 
]

{ #category : #accessing }
TWCreationStrategy >> watchdog [
	^ watchdog
]

{ #category : #accessing }
TWCreationStrategy >> watchdog: anObject [
	watchdog := anObject
]
