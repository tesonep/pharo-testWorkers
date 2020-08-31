Extension { #name : #TestResult }

{ #category : #'*TestWorkers-Runner' }
TestResult >> mergeWith: aTestResult [ 
	
	failures addAll: aTestResult failures.
	errors addAll: aTestResult errors.
	passed addAll: aTestResult passed.
	skipped addAll: aTestResult skipped.
]
