Class {
	#name : #TWCopyImageCreationStrategy,
	#superclass : #TWCreationStrategy,
	#instVars : [
		'originalImageZip'
	],
	#classInstVars : [
		'defaultOriginalImageZip'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWCopyImageCreationStrategy class >> defaultOriginalImageZip [
	^ defaultOriginalImageZip ifNil: [ FileLocator workingDirectory / 'template.zip' ]
]

{ #category : #accessing }
TWCopyImageCreationStrategy class >> defaultOriginalImageZip: anObject [
	defaultOriginalImageZip := anObject
]

{ #category : #accessing }
TWCopyImageCreationStrategy class >> description [

	^ 'Create Template from existing Zip'
]

{ #category : #'instances-creation' }
TWCopyImageCreationStrategy >> downloadAndUnzip [ 

	| zipFile zipArchive |
	zipFile := self templatePath / self originalImageZip basename.
	
	zipFile exists 
		ifFalse: [ self originalImageZip copyTo: self templatePath ] . 
	
	zipArchive := ZipArchive new readFrom: zipFile.
	
	zipArchive extractAllTo: self templatePath overwrite: true.
	zipArchive close.
	
	zipFile ensureDelete.
]

{ #category : #accessing }
TWCopyImageCreationStrategy >> originalImageZip [
	^ originalImageZip ifNil: [ self class defaultOriginalImageZip  ]
]

{ #category : #accessing }
TWCopyImageCreationStrategy >> originalImageZip: anObject [
	originalImageZip := anObject
]
