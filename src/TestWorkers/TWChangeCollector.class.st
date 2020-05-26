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
