Extension { #name : #TestFailure }

{ #category : #'*TestWorkers-Connector' }
TestFailure >> twAnnounce: aTestCase toResult: aTestResult [

	aTestResult addFailure: aTestCase with: self
]
