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

	^ ('http://files.pharo.org/image/90/{1}.zip' format: { SystemVersion current imageName }) asUrl
]
