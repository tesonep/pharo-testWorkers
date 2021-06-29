Extension { #name : #TestCase }

{ #category : #'*TestWorkers-UI' }
TestCase class >> runTestInClient: aTWClient [ 
	
	^ aTWClient runTestClass: self
]
