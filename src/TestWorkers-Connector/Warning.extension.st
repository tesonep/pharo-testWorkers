Extension { #name : #Warning }

{ #category : #'*TestWorkers-Connector' }
Warning >> twAnnounce: aTestCase toResult: aTestResult [

	aTestResult addFailure: aTestCase with: self
]
