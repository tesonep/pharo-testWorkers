Class {
	#name : #TWChangeCollector,
	#superclass : #Object,
	#instVars : [
		'repository'
	],
	#category : #'TestWorkers-Changes'
}

{ #category : #'system-events' }
TWChangeCollector >> classAdded: aClassAdded [ 
	
	repository currentCommit addChange: (TWClassAdded fromAnnouncement: aClassAdded)
]

{ #category : #'system-events' }
TWChangeCollector >> classModified: aClassModified [ 
	
	repository currentCommit addChange: (TWClassModified fromAnnouncement: aClassModified)
]

{ #category : #'system-events' }
TWChangeCollector >> classRemoved: aClassRemoved [ 
	
	repository currentCommit addChange: (TWClassRemoved fromAnnouncement: aClassRemoved)	
]

{ #category : #'system-registration' }
TWChangeCollector >> ensureRegistered [

	SystemAnnouncer uniqueInstance unsubscribe: self.

	SystemAnnouncer uniqueInstance weak
		when: ClassRemoved send: #classRemoved: to: self;
		when: ClassAdded send: #classAdded: to: self;
		when: ClassCommented send: #classCommented: to: self;
		when: ClassRenamed send: #classRenamed: to: self;
		when: ClassReorganized send: #classReorganized: to: self;
		when: ClassRecategorized send: #classRecategorized: to: self;
		when: ClassModifiedClassDefinition send: #classModified: to: self.

	SystemAnnouncer uniqueInstance weak
		when: MethodAdded send: #methodAdded: to: self;
		when: MethodModified send: #methodModified: to: self;
		when: MethodRemoved send: #methodRemoved: to: self;
		when: MethodRecategorized send: #methodRecategorized: to: self.

]

{ #category : #'system-events' }
TWChangeCollector >> methodAdded: aMethodAdded [

	repository currentCommit
		addChange: (TWMethodAdded fromAnnouncement: aMethodAdded)
]

{ #category : #'system-events' }
TWChangeCollector >> methodModified: aMethodModified [
	| change |
	"As the category of the method is informed before we need to check if it exists as the last change"
	repository currentCommit lastChange
		ifNotNil: [ :lastChange | 
			(lastChange isMethodModified
				and: [ lastChange definition = aMethodModified newMethod sourceCode ])
				ifTrue: [ lastChange updateFromAnnouncement: aMethodModified. ^ self ]].

	change := TWMethodModified fromAnnouncement: aMethodModified.
	repository currentCommit addChange: change
]

{ #category : #'system events' }
TWChangeCollector >> methodRecategorized: aMethodRecategorized [ 
	
	repository currentCommit
		addChange: (TWMethodModified new fromRecategorization: aMethodRecategorized; yourself)
]

{ #category : #accessing }
TWChangeCollector >> repository [
	^ repository
]

{ #category : #accessing }
TWChangeCollector >> repository: anObject [
	repository := anObject
]

{ #category : #'system-registration' }
TWChangeCollector >> unregister [

	SystemAnnouncer uniqueInstance unsubscribe: self

]
