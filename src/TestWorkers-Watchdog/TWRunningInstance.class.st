Class {
	#name : #TWRunningInstance,
	#superclass : #TWManagedWorkerInstanceState,
	#instVars : [
		'lastPong',
		'testId'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #operations }
TWRunningInstance >> heartbeat [

	(DateAndTime now - lastPong) > 80 seconds 
		ifTrue: [ 
			instance instanceId: nil.
			instance state: (TWNonExistingInstance on: instance).  
			instance state checkState ]
]

{ #category : #initialization }
TWRunningInstance >> initialize [ 
	
	super initialize.
	lastPong := DateAndTime now.
]

{ #category : #operations }
TWRunningInstance >> killed: aTWKilled [

	instance instanceId = aTWKilled instanceId
		ifTrue: [ 
			instance instanceId: nil.
			instance state: (TWMaterializedInstance on: instance) ]
]

{ #category : #accessing }
TWRunningInstance >> lastPong [

	^ lastPong
]

{ #category : #operations }
TWRunningInstance >> pongReceived: aTWPong [ 
	
	instance instanceId = aTWPong instanceId 
		ifFalse: [ ^ self ].
	
	testId := aTWPong testId.
	lastPong := DateAndTime now
	
]

{ #category : #accessing }
TWRunningInstance >> stateName [

	^ 'Running'
]

{ #category : #operations }
TWRunningInstance >> testId [

	^ testId
	
]
