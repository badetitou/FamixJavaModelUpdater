Trait {
	#name : #TFJMUEntityFactory,
	#instVars : [
		'famixModel',
		'fileAnchorPath',
		'fastModel'
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
TFJMUEntityFactory >> fastModel [

	^ fastModel
]

{ #category : #accessing }
TFJMUEntityFactory >> fastModel: anObject [

	fastModel := anObject
]

{ #category : #accessing }
TFJMUEntityFactory >> fastScopeOwnerOf: aFASTJavaNode [

	^ (aFASTJavaNode atAnyScope: { 
			   FASTJavaMethodEntity.
			   FASTJavaClassDeclaration }) ifNotNil: [ :scopes | scopes anyOne ]
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

{ #category : #'model - create' }
TFJMUEntityFactory >> retrieveClassFromModel: aClassName [

	^ (fastModel allWithType: FASTJavaImportDeclaration)
		  detect: [ :importDeclaration | 
			  importDeclaration declarationName name = aClassName ]
		  ifOne: [ :importDeclaration | 
			  self famixModel allPackages
				  detect: [ :pa | 
					  pa qualifiedName
					  = importDeclaration declarationName namespace fullName ]
				  ifOne: [ :package | 
					  package types
						  detect: [ :type | type name = aClassName ]
						  ifNone: [ nil ] ] ]
		  ifNone: [ 
			  self famixModel allModelTypes  asOrderedCollection
				  detect: [ :class | class name = aClassName ]
				  ifNone: [ nil ] ]
]
