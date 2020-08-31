Class {
	#name : #TWRemoteTestsResult,
	#superclass : #DTPluginResult,
	#instVars : [
		'client'
	],
	#category : #'TestWorkers-UI'
}

{ #category : #accessing }
TWRemoteTestsResult >> buildLeavesFrom: aCollection type: testResultType [
	^ aCollection collect: [ :t | DTTestLeaf content: t type: testResultType ]
]

{ #category : #accessing }
TWRemoteTestsResult >> buildTreeForUI [
	
	^ DTTreeNode new
		subResults:
			{
			DTTreeNode new
				name: 'Remaining Tests';
				subResults: self remainingTestNodes;
				yourself.			
DTTreeNode new
				name: DTTestResultType error pluralName;
				subResults: (self buildLeavesFrom: client testResults errors asOrderedCollection type: DTTestResultType error);
				yourself.
			DTTreeNode new
				name: DTTestResultType fail pluralName;
				subResults: (self buildLeavesFrom: client testResults failures asOrderedCollection type: DTTestResultType fail).
			DTTreeNode new
				name: DTTestResultType skipped pluralName;
				subResults: (self buildLeavesFrom: client testResults skipped asOrderedCollection type: DTTestResultType skipped).
			DTTreeNode new
				name: DTTestResultType pass pluralName;
				subResults: (self buildLeavesFrom: client testResults passed asOrderedCollection type: DTTestResultType pass)
		};
		yourself
]

{ #category : #accessing }
TWRemoteTestsResult >> client [
	^ client
]

{ #category : #accessing }
TWRemoteTestsResult >> client: anObject [
	client := anObject
]

{ #category : #nodes }
TWRemoteTestsResult >> remainingTestNodes [
	^ client requests values collect: [ :e | DTTreeLeaf content: e ].
]
