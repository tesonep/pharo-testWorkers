Extension { #name : #DirtyTestError }

{ #category : #'*TestWorkers-Connector' }
DirtyTestError >> twAnnounce: aTestCase toResult: aTestResult [

	executionEnvironment isMainTestProcessFailed ifTrue: [ 
		"The main test process errors are handled by SUnit using same message.
		So the actual domain test error is already counted in result"
		^self].
	
	"If main test process was completed successfully
	we should mark test as failed due to dirty system state"
	aTestResult addError: aTestCase with: self
]
