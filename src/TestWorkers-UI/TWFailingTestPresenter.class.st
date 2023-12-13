Class {
	#name : #TWFailingTestPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'testResult',
		'stackList',
		'codePresenter'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #layout }
TWFailingTestPresenter class >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		add: #stackList;
		add: #codePresenter;
		yourself
]

{ #category : #initialization }
TWFailingTestPresenter >> connectPresenters [

	stackList whenSelectionChangedDo: [ self updateCodePresenter ]
]

{ #category : #initialization }
TWFailingTestPresenter >> initializePresenters [

	stackList := self newTable
		addColumn: (SpImageTableColumn title: 'Class' 
			evaluated: #displayClassName);
		addColumn: (SpStringTableColumn title: 'Method'
			evaluated: #displayMethodName);
		yourself.
	 
	codePresenter := self newCode.	
	codePresenter beNotEditable.
]

{ #category : #initialization }
TWFailingTestPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter title: testResult exceptionClassName , ': ' , testResult exceptionMessage.
	aWindowPresenter initialExtent: 900@600
]

{ #category : #accessing }
TWFailingTestPresenter >> selectedContext [
	
	^ stackList selectedItem ifNil: [ stackList items first ]
]

{ #category : #initialization }
TWFailingTestPresenter >> setModelBeforeInitialization: aTestResult [

	testResult := aTestResult
]

{ #category : #initialization }
TWFailingTestPresenter >> updateCodePresenter [
	
	| executedInterval |
	codePresenter text: self selectedContext compiledMethod sourceCode.
	codePresenter beForMethod: self selectedContext compiledMethod.

	executedInterval := self selectedContext executedInterval.
	
	codePresenter
		addTextSegmentDecoration:
			(SpTextPresenterDecorator new
				highlightColor: (Color orange alpha: 0.5);
				underlineColor: (Color white alpha: 0);
				interval: (executedInterval first to: executedInterval last + 1);
				yourself)

]

{ #category : #initialization }
TWFailingTestPresenter >> updatePresenter [ 

	stackList items: testResult stackTrace
]
