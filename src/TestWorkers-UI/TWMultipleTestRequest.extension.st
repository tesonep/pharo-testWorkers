Extension { #name : #TWMultipleTestRequest }

{ #category : #'*TestWorkers-UI' }
TWMultipleTestRequest >> buildSuite [
	
	| suite |
	
	suite := TestSuite new.
	tests do: [ :test |
		suite addTest: ((self class environment classNamed: test key) selector: test value).
	].
	
	^ suite.
]

{ #category : #'*TestWorkers-UI' }
TWMultipleTestRequest >> drTestsBrowse [
]

{ #category : #'*TestWorkers-UI' }
TWMultipleTestRequest >> drTestsName [
	
	^ ', ' join: (tests collect: [ :test | test key asString , ' >> ' , test value asString ])
]
