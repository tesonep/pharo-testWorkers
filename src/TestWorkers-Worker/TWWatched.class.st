Class {
	#name : #TWWatched,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'instanceId'
	],
	#category : #'TestWorkers-Worker'
}

{ #category : #'as yet unclassified' }
TWWatched >> executePing [

	[TWPong new
		instanceId: instanceId;
		sendOn: connection] onErrorDo: [  ]
]

{ #category : #'as yet unclassified' }
TWWatched >> informationRequested: aTWInfoRequest [

	[ 
	TWInfoResponse new
		instanceId: instanceId;
		sendOn: connection to: aTWInfoRequest replyQueue] onErrorDo: [  ]
]

{ #category : #initialization }
TWWatched >> initialize [

	super initialize.
	instanceId := UUID new.
]

{ #category : #configuration }
TWWatched >> inputQueueName [ 

	^ TWWatchdogMessage workerExchange 
]

{ #category : #operations }
TWWatched >> instanceId [

	^ instanceId
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

	[	
		TWKilled new 
			instanceId: instanceId;
			sendOn: connection.
		
		TWRunner uniqueInstance stop] 
		ensure: [Smalltalk snapshot: false andQuit: true].
]
