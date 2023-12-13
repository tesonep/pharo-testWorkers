Class {
	#name : #TWCurrentPharoCommitCreationStrategy,
	#superclass : #TWCreationStrategy,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWCurrentPharoCommitCreationStrategy class >> description [

	^ 'Create Template from Current Pharo Commit'
]

{ #category : #accessing }
TWCurrentPharoCommitCreationStrategy >> imageUrl [

	^ ('http://files.pharo.org/image/{1}/{2}.zip' format: {
			   (SystemVersion current majorMinor: '').
			   SystemVersion current imageName }) asUrl
]
