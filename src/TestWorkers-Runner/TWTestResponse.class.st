Class {
	#name : #TWTestResponse,
	#superclass : #TWMessage,
	#instVars : [
		'testResults',
		'testClassName'
	],
	#category : #'TestWorkers-Runner'
}

{ #category : #sending }
TWTestResponse >> execute: client [

	client runTestResponse: self
]

{ #category : #sending }
TWTestResponse >> handleSendError: anError on: connection [

	TWTestExecutionError new
		testClassName: testClassName;
		exceptionMessage: anError messageText;
		serializedException: (self tryToSerialize: anError);
		uuid: self uuid;
		sendOn: connection
		
]

{ #category : #sending }
TWTestResponse >> queueName [

	^ 'testResponse'
	
]

{ #category : #accessing }
TWTestResponse >> testClassName [
	^ testClassName
]

{ #category : #accessing }
TWTestResponse >> testClassName: anObject [
	testClassName := anObject
]

{ #category : #accessing }
TWTestResponse >> testResults [

	^ testResults
]

{ #category : #accessing }
TWTestResponse >> testResults: aTestResult [ 
	testResults := aTestResult
]

{ #category : #sending }
TWTestResponse >> tryToSerialize: anError [

	[ ^ FLSerializer serializeToByteArray: anError  ] 
		onErrorDo: [ ^ nil ].
]
