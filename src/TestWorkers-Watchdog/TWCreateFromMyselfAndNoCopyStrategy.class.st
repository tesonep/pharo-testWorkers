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
"		watchdog := TWWatchdog new
		rootDirectory: 'C:\pharo9_64' asFileReference;
		useCreationStrategy: TWCreateFromMyselfAndNoCopyStrategy ;
		numberOfInstances: 15;
		yourself.
		
	watchdog start.
	
	(TWWatchdogPresenter on: watchdog)
		openWithSpec.
	watchdog	startInstances.
	""EXEC in 2 steps ---- STOP THERE""
	
	packages := RPackageOrganizer default packages.
	conf := DTPluginConfiguration
		items:
			(packages
				flatCollect:
					[ :p | p definedClasses select: [ :c | c allSuperclasses includes: LwTestCase ] ])
		packages:packages.
	plugin := TWRemoteTestsPluginForLifeware. 
	drTest := DrTests on:(Array with: plugin).
	drTest currentPlugin finishCallbackBlock: [ :e | |stream| stream := 'testResults.json' asXFilename writeStreamX. [  stream nextPutAll: drTest pluginResult client testResults jsonized ]ensure: [ stream close ]. Transcript open; show: 'TESTS FINISHED' ].
	drTest openWithSpec.
	(drTest runPluginFor: conf).
	
	
	watchdog stop
"

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

	(SourceFiles changesFileStream isNil or: [ 
		 SourceFiles changesFileStream closed ]) ifFalse: [ 
		SmalltalkImage current  closeSourceFiles.
		SmalltalkImage current  saveChangesInFileNamed:
			(SmalltalkImage current  fullNameForChangesNamed: self templatePath /  (SmalltalkImage current imageFile base, '-TW')).
		SmalltalkImage current  openSourceFiles ].

	isBackup := SmalltalkImage current backupImageInFileNamed:
		            self templatePath / self templateName.

	isBackup
		ifFalse: [ watchdog start ]
		ifTrue: [ 
			TWClient uniqueInstance stop.
			Abort signal ]
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
