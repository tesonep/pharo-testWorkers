Class {
	#name : #TWTestResults,
	#superclass : #TestResult,
	#instVars : [
		'executingContext'
	],
	#category : #'TestWorkers-Connector-Results'
}

{ #category : #'fuel support' }
TWTestResults class >> fuelIgnoredInstanceVariableNames [

	^#(executingContext)
]

{ #category : #adding }
TWTestResults >> addError: aTestcase [

	self error: 'Use #addError:with:, I need more details'
]

{ #category : #adding }
TWTestResults >> addError: aTestCase with: anError [

	super addError: (aTestCase asTWTestCaseResult
			 storeError: anError upTo: executingContext;
			 yourself)
]

{ #category : #adding }
TWTestResults >> addFailure: aTestcase [

	self error: 'Use #addFailure:with:, I need more details'
]

{ #category : #adding }
TWTestResults >> addFailure: aTestCase with: anError [

	super addFailure: (aTestCase asTWTestCaseResult
			 storeError: anError upTo: executingContext;
			 yourself)
]

{ #category : #adding }
TWTestResults >> addPass: aTestCase [

	super addPass: aTestCase asTWTestCaseResult
]

{ #category : #adding }
TWTestResults >> addSkip: aTestCase [

	super addSkip: aTestCase asTWTestCaseResult
]

{ #category : #accessing }
TWTestResults >> executingContext: aContext [ 
	executingContext := aContext
]

{ #category : #querying }
TWTestResults >> isErrorFor: aClass selector: aString [

	^ self errors anySatisfy: [ :testCaseResult | 
		  testCaseResult testClassName = aClass name and: [ testCaseResult testSelector == aString ] ]
]

{ #category : #querying }
TWTestResults >> isFailureFor: aClass selector: aString [

	^ self failures anySatisfy: [ :testCaseResult | 
		  testCaseResult testClassName = aClass name and: [ testCaseResult testSelector == aString ] ]
]

{ #category : #querying }
TWTestResults >> isPassedFor: aClass selector: aString [

	^ self passed anySatisfy: [ :testCaseResult | 
		  testCaseResult testClassName = aClass name and: [ testCaseResult testSelector == aString ] ]
]

{ #category : #querying }
TWTestResults >> isSkippedFor: aClass selector: aString [

	^ self skipped anySatisfy: [ :testCaseResult | 
		  testCaseResult testClassName = aClass name and: [ testCaseResult testSelector == aString ] ]
]

{ #category : #running }
TWTestResults >> runCase: aTestCase [
	[
	aTestCase announce: TestCaseStarted withResult: self.
	aTestCase runCaseManaged.
	aTestCase announce: TestCaseEnded  withResult: self.
	self addPass: aTestCase]
		on: self class failure , self class skip, self class warning, self class error
		do: [:ex | ex twAnnounce: aTestCase toResult: self]
]
