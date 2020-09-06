Extension { #name : #SystemVersion }

{ #category : #'*TestWorkers-Watchdog' }
SystemVersion >> imageName [

	| arch |

	"Pharo9.0-SNAPSHOT.build.634.sha.658326a.arch.64bit.zip"

	arch := Smalltalk vm is32bit 
					ifTrue: [ '32bit' ]
					ifFalse: [ '64bit' ].	

	^ String streamContents: [ :aStream | 
		aStream 
			nextPutAll: self type;
			print: self major;
			nextPut: $.;
			print: self minor;
			nextPutAll: '-SNAPSHOT.build.';
			print: self build;
			nextPutAll: '.sha.';
			nextPutAll: self commitHashShort;
			nextPutAll: '.arch.';
			nextPutAll: arch
		 ]
]
