Extension { #name : #Error }

{ #category : #'*TestWorkers-Connector' }
Error >> twAnnounce: aTestCase toResult: aTestResult [

	aTestResult addError: aTestCase with: self
]
