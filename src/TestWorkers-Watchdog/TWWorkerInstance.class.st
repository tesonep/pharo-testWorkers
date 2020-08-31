Class {
	#name : #TWWorkerInstance,
	#superclass : #Object,
	#instVars : [
		'path'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #'instance creation' }
TWWorkerInstance class >> directory: aPath [ 

	^ self basicNew
		path: aPath;
		yourself.
]

{ #category : #accesssing }
TWWorkerInstance >> path: aDiskDirectoryEntry [ 
	path := aDiskDirectoryEntry
]
