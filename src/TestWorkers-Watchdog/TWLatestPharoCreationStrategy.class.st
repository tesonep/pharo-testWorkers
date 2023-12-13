Class {
	#name : #TWLatestPharoCreationStrategy,
	#superclass : #TWCreationStrategy,
	#category : #'TestWorkers-Watchdog'
}

{ #category : #accessing }
TWLatestPharoCreationStrategy class >> description [

	^ 'Create Template from Latest Pharo'
]

{ #category : #accessing }
TWLatestPharoCreationStrategy >> imageUrl [

	^ ('http://files.pharo.org/image/{1}/latest-64.zip' format:
		   { (SystemVersion current majorMinor: '') }) asUrl
]
