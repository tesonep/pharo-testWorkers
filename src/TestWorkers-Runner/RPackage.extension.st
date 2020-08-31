Extension { #name : #RPackage }

{ #category : #'*TestWorkers-Runner' }
RPackage >> asTestSuite [
	
	| testSuite testClasses |
	
	testSuite := TestSuite named: self name.
	testClasses := self definedClasses reject: [ :e | e isAbstract and: [ self isTestCase not ] ].
	
	testClasses do: [ :e | testSuite addTests: e buildSuite tests ].
	^ testSuite
]
