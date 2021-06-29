Class {
	#name : #TWFilterableTreePresenter,
	#superclass : #DTFilterableListPresenter,
	#category : #'TestWorkers-UI'
}

{ #category : #accessing }
TWFilterableTreePresenter >> childrenBlock: aFullBlockClosure [ 
	
	^ self listPresenter children: aFullBlockClosure 
]

{ #category : #initialization }
TWFilterableTreePresenter >> initializeWidgets [

	labelPresenter := self newLabel.
	listPresenter := self newTree.
	filterTextInput := self newTextInput
								placeholder: 'Filter...';
								whenTextChangedDo: [ self filterList ];
								autoAccept: true;
								yourself
]

{ #category : #initialization }
TWFilterableTreePresenter >> selectAll [ 
	
	^ self listPresenter selectPaths: ((1 to: self listPresenter roots size) collect: [ :i | { i }]).
]
