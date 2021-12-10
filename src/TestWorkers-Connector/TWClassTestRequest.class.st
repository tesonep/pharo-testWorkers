Class {
	#name : #TWClassTestRequest,
	#superclass : #TWTestRequest,
	#instVars : [
		'testClassName'
	],
	#category : #'TestWorkers-Connector'
}

{ #category : #accessing }
TWClassTestRequest >> testClassName [
	^ testClassName
]

{ #category : #accessing }
TWClassTestRequest >> testClassName: anObject [
	testClassName := anObject
]
