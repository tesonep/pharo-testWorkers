Extension { #name : #TWTestExecutionError }

{ #category : #'*TestWorkers-UI' }
TWTestExecutionError >> drTestsBrowse [

	(self class environment at: testClassName) browse
]

{ #category : #'*TestWorkers-UI' }
TWTestExecutionError >> drTestsName [
	
	^ testClassName , ' - ' , exceptionMessage
]
