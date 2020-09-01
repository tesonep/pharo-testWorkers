Class {
	#name : #TWLatestPharoCreationStrategy,
	#superclass : #TWCreationStrategy,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWLatestPharoCreationStrategy >> imageUrl [

	^ 'http://files.pharo.org/image/90/latest-64.zip' asUrl
]
