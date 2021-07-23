Class {
	#name : #TWWatched,
	#superclass : #TWAbstractConnected,
	#instVars : [
		'heartbeatService',
		'testId',
		'instanceId'
	],
	#category : #'TestWorkers-Worker'
}

{ #category : #operations }
TWWatched >> executePing [

	[TWPong new
		instanceId: instanceId;
		testId: testId;
		sendOn: connection] onErrorDo: [  ]
]

{ #category : #operations }
TWWatched >> informationRequested: aTWInfoRequest [

	[ 
	TWInfoResponse new
		instanceId: instanceId;
		sendOn: connection to: aTWInfoRequest replyQueue] onErrorDo: [  ]
]

{ #category : #initialization }
TWWatched >> initialize [

	super initialize.
	instanceId := UUID new
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

	^ Processor highIOPriority
]

{ #category : #operations }
TWWatched >> shutdown [

	[	
		heartbeatService ifNotNil: [ heartbeatService stop ].
		
		TWKilled new 
			instanceId: instanceId;
			sendOn: connection.
		
		TWRunner uniqueInstance stop] 
		ensure: [Smalltalk snapshot: false andQuit: true].
]

{ #category : #operations }
TWWatched >> start [ 
	
	super start.
	
	TKTConfiguration serviceManager services 
		detect: [ :aService | aService name = 'TWPingService' ]
		ifFound: [ :oldService | 
			oldService stop ].
	
	heartbeatService := TKTParameterizableService new.
	heartbeatService name: 'TWPingService'.
	heartbeatService stepDelay: 1 second.
	heartbeatService step: [ 
		self executePing ].
	heartbeatService start.

]

{ #category : #operations }
TWWatched >> testId: anObject [

	testId := anObject.
	self executePing 
]
