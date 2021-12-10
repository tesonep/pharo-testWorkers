Extension { #name : #TWTestExecutionError }

{ #category : #'*TestWorkers-UI' }
TWTestExecutionError >> drTestsBrowse [

	testRequest drTestsBrowse
]

{ #category : #'*TestWorkers-UI' }
TWTestExecutionError >> drTestsName [
	
	^ testRequest drTestsName , ' - ' , exceptionMessage
]
