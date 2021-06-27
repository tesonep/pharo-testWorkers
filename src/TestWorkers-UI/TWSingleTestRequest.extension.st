Extension { #name : #TWSingleTestRequest }

{ #category : #'*TestWorkers-UI' }
TWSingleTestRequest >> buildSuite [
	
	| suite |
	
	suite := TestSuite new.
	suite addTest: ((self class environment classNamed: testClassName) selector: testSelector).
	
	^ suite.
]

{ #category : #'*TestWorkers-UI' }
TWSingleTestRequest >> drTestsBrowse [

	Smalltalk tools browser
		openOnClass: (self class environment classNamed: testClassName)
		selector: testSelector
]

{ #category : #'*TestWorkers-UI' }
TWSingleTestRequest >> drTestsName [
	
	^ testClassName asString , ' >> ' , testSelector asString
]
