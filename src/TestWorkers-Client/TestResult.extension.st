Extension { #name : #TestResult }

{ #category : #'*TestWorkers-Client' }
TestResult >> basicErrors [
	
	^ errors
]

{ #category : #'*TestWorkers-Client' }
TestResult >> basicFailures [
	
	^ failures
]

{ #category : #'*TestWorkers-Client' }
TestResult >> basicPassed [ 
	
	^ passed
]

{ #category : #'*TestWorkers-Client' }
TestResult >> basicSkipped [
	
	^ skipped
]

{ #category : #'*TestWorkers-Client' }
TestResult >> mergeWith: aTestResult [ 
	
	failures addAll: aTestResult basicFailures.
	errors addAll: aTestResult basicErrors.
	passed addAll: aTestResult basicPassed.
	skipped addAll: aTestResult basicSkipped.
]
