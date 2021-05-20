Extension { #name : #TestSkipped }

{ #category : #'*TestWorkers-Connector' }
TestSkipped >> twAnnounce: aTestCase toResult: aTestResult [
	aTestResult addSkip: aTestCase.
]
