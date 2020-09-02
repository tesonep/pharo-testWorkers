Class {
	#name : #TWCurrentPharoCommitCreationStrategy,
	#superclass : #TWCreationStrategy,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWCurrentPharoCommitCreationStrategy >> imageUrl [

	^ 'http://files.pharo.org/image/90/latest-64.zip' asUrl
]
