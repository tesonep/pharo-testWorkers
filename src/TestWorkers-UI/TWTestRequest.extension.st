Extension { #name : #TWTestRequest }

{ #category : #'*TestWorkers-UI' }
TWTestRequest >> drTestsBrowse [
	(self class environment at: testClassName) browse
]

{ #category : #'*TestWorkers-UI' }
TWTestRequest >> drTestsName [
	
	^ testClassName 
]
