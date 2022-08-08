Trait {
	#name : #TFJMUEntityFactory,
	#instVars : [
		'famixModel',
		'fileAnchorPath'
	],
	#category : #'FamixJavaModelUpdater-Updater'
}

{ #category : #'model - create' }
TFJMUEntityFactory >> create: aFamixClass [

	^ self famixModel add: aFamixClass new
]

{ #category : #'model - create' }
TFJMUEntityFactory >> create: aFamixClass from: aFastJavaEntity [

	| entity |
	entity := self create: aFamixClass.
	self fileAnchorPath ifNotNil: [ :famixSourceAnchor |
		entity sourceAnchor:
			(self generateAnchorBasedOn: famixSourceAnchor for: aFastJavaEntity) ].
	^ entity
]

{ #category : #accessing }
TFJMUEntityFactory >> famixModel [

	^ famixModel
]

{ #category : #accessing }
TFJMUEntityFactory >> famixModel: anObject [

	famixModel := anObject
]

{ #category : #accessing }
TFJMUEntityFactory >> fileAnchorPath [

	^ fileAnchorPath
]

{ #category : #accessing }
TFJMUEntityFactory >> fileAnchorPath: anObject [

	fileAnchorPath := anObject
]

{ #category : #'model - create' }
TFJMUEntityFactory >> generateAnchorBasedOn: famixSourceAnchor for: aFastJavaEntity [

	^ (self create: FamixJavaIndexedFileAnchor)
		  startPos: aFastJavaEntity startPos;
		  endPos: aFastJavaEntity endPos;
		  fileName: famixSourceAnchor;
		  yourself
]
