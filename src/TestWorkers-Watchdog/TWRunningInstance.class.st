Class {
	#name : #TWRunningInstance,
	#superclass : #TWWorkerInstanceState,
	#instVars : [
		'lastPong'
	],
	#category : #'TestWorkers-Watchdog'
}

{ #category : #initialization }
TWRunningInstance >> initialize [ 
	
	super initialize.
	lastPong := DateAndTime now.
]

{ #category : #operations }
TWRunningInstance >> pongReceived: aTWPong [ 
	
	lastPong := DateAndTime now
	
]

{ #category : #accessing }
TWRunningInstance >> stateName [

	^ 'Running'
]
