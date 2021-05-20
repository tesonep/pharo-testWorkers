Extension { #name : #TestCase }

{ #category : #'*TestWorkers-Connector' }
TestCase >> asTWTestCaseResult [
	
	^ TWTestCaseResult from: self
]
