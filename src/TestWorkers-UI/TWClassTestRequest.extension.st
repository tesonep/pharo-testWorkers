Extension { #name : #TWClassTestRequest }

{ #category : #'*TestWorkers-UI' }
TWClassTestRequest >> buildSuite [
	
	^ (self class environment classNamed: testClassName) buildSuite 
]

{ #category : #'*TestWorkers-UI' }
TWClassTestRequest >> drTestsBrowse [
	(self class environment at: testClassName) browse
]

{ #category : #'*TestWorkers-UI' }
TWClassTestRequest >> drTestsName [
	
	^ testClassName asString
]
