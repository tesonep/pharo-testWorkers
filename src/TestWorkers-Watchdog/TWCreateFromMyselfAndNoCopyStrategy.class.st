Class {
	#name : #TWCreateFromMyselfAndNoCopyStrategy,
	#superclass : #TWCreationStrategy,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWCreateFromMyselfAndNoCopyStrategy class >> description [

	^ 'Light copy from current image'
]

{ #category : #'As yet unclassified' }
TWCreateFromMyselfAndNoCopyStrategy class >> scriptToRunTheTests [
"	| watchdog |
	watchdog := TWWatchdog new
		rootDirectory: 'C:\pharo9_64' asFileReference;
		useCreationStrategy: TWCreateImageFromMyselfStrategy ;
		numberOfInstances: 2;
		yourself.
		
	watchdog start.
	
	(TWWatchdogPresenter on: watchdog)
		openWithSpec.
	watchdog	startInstances.
		
	package := 'Accounts Testing' asPackage.
	conf := DTPluginConfiguration
		items:
			((Array with: package)
				flatCollect:
					[ :p | p definedClasses select: [ :c | c allSuperclasses includes: LwTestCase ] ])
		packages:(Array with: package).
	plugin := TWRemoteTests.
	drTest := DrTests on:(Array with: plugin).
	drTest openWithSpec.
	(drTest runPluginFor: conf) 
	drTest pluginResult buildTreeForUI.
	




watchdog stop"

]

{ #category : #'instances-creation' }
TWCreateFromMyselfAndNoCopyStrategy >> createTemplate [

	| isBackup |
	watchdog stop.
	self templatePath ensureCreateDirectory.
	[ 
	SmalltalkImage current sourcesFile copyTo:
		self templatePath / SmalltalkImage current sourcesFile basename ]
		on: FileExists
		do: [ :ex | "Ok to proceed" ].

	isBackup := SmalltalkImage current backupImageInFileNamed:
		            self templatePath / self templateName.

	isBackup
		ifFalse: [ watchdog start ]
		ifTrue: [ Abort signal ]
]

{ #category : #'instances-creation' }
TWCreateFromMyselfAndNoCopyStrategy >> instanceDirectorWithRoot: aFileReferenceToRootDirectory andImageIndex: anIndex [

	^ aFileReferenceToRootDirectory
]

{ #category : #accessing }
TWCreateFromMyselfAndNoCopyStrategy >> templateFolderName [

	^ '.'
]

{ #category : #accessing }
TWCreateFromMyselfAndNoCopyStrategy >> templateName [

	^ SmalltalkImage current imageFile base, '-TW', '.image'
]
