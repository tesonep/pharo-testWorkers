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
