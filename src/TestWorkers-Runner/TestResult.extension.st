Extension { #name : #TestResult }

{ #category : #'*TestWorkers-Runner' }
TestResult >> basicErrors [
	
	^ errors
]

{ #category : #'*TestWorkers-Runner' }
TestResult >> basicFailures [
	
	^ failures
]

{ #category : #'*TestWorkers-Runner' }
TestResult >> basicPassed [ 
	
	^ passed
]

{ #category : #'*TestWorkers-Runner' }
TestResult >> basicSkipped [
	
	^ skipped
]

{ #category : #'*TestWorkers-Runner' }
TestResult >> mergeWith: aTestResult [ 
	
	failures addAll: aTestResult basicFailures.
	errors addAll: aTestResult basicErrors.
	passed addAll: aTestResult basicPassed.
	skipped addAll: aTestResult basicSkipped.
]
