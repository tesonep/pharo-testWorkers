Class {
	#name : #TWWatched,
	#superclass : #TWAbstractConnected,
	#category : #'TestWorkers-Runner'
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
