Class {
	#name : #TWWatched,
	#superclass : #TWAbstractConnected,
	#category : #'TestWorkers-Worker'
}

{ #category : #'as yet unclassified' }
TWWatched >> executePing [

	[TWPong new
		sendOn: connection] onErrorDo: [  ]
]

{ #category : #configuration }
TWWatched >> inputQueueName [ 

	^ '/exchange/workers'
]

{ #category : #configuration }
TWWatched >> processName [ 
	^ 'TWWatched'
]

{ #category : #configuration }
TWWatched >> processPriority [ 

	^ Processor userInterruptPriority 
]

{ #category : #operations }
TWWatched >> shutdown [

	[TWRunner uniqueInstance stop] 
		ensure: [Smalltalk snapshot: false andQuit: true].
]
