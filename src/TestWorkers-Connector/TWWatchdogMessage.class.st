Class {
	#name : #TWWatchdogMessage,
	#superclass : #TWMessage,
	#category : #'TestWorkers-Connector'
}

{ #category : #'as yet unclassified' }
TWWatchdogMessage class >> watchdogQueue [ 

	^ 'watchdog-' , NetNameResolver localHostName
]

{ #category : #'as yet unclassified' }
TWWatchdogMessage class >> workerExchange [ 

	^ '/exchange/' , self workerExchangeName
]

{ #category : #'as yet unclassified' }
TWWatchdogMessage class >> workerExchangeName [

	^ 'workers-' , NetNameResolver localHostName
]

{ #category : #'as yet unclassified' }
TWWatchdogMessage >> watchdogQueue [ 

	^ self class watchdogQueue
]

{ #category : #'as yet unclassified' }
TWWatchdogMessage >> workerExchange [ 

	^ self class workerExchange 
]
