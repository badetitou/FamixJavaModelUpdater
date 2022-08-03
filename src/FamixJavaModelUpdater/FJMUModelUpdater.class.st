"
This is the main class of the FamixJava Model Updater project.
To use it:

- create a new instance
- set instances
	- `famixEntity` with the FamixJavaClass you want to update
	- `famixModel` the mooseModel in which is the famixEntity
	- `fastModel` the FASTJava model used to perform the update
- send the `update` message
"
Class {
	#name : #FJMUModelUpdater,
	#superclass : #FASTJavaVisitor,
	#classTraits : 'FamixJavaVisitor classTrait',
	#instVars : [
		'fastModel',
		'famixModel',
		'famixEntity',
		'cleaner',
		'fileAnchorPath'
	],
	#category : #FamixJavaModelUpdater
}

{ #category : #accessing }
FJMUModelUpdater >> cleaner [

	^ cleaner
]

{ #category : #accessing }
FJMUModelUpdater >> cleaner: anObject [

	cleaner := anObject
]

{ #category : #'model - create' }
FJMUModelUpdater >> create: aFamixClass [

	^ self famixModel add: aFamixClass new
]

{ #category : #'model - create' }
FJMUModelUpdater >> create: aFamixClass from: aFastJavaEntity [

	| entity |
	entity := self create: aFamixClass.
	self fileAnchorPath ifNotNil: [ :famixSourceAnchor |
		entity sourceAnchor:
			(self generateAnchorBasedOn: famixSourceAnchor for: aFastJavaEntity) ].
	^ entity
]

{ #category : #accessing }
FJMUModelUpdater >> famixEntity [

	^ famixEntity
]

{ #category : #accessing }
FJMUModelUpdater >> famixEntity: anObject [

	famixEntity := anObject
]

{ #category : #accessing }
FJMUModelUpdater >> famixModel [

	^ famixModel
]

{ #category : #accessing }
FJMUModelUpdater >> famixModel: anObject [

	famixModel := anObject
]

{ #category : #accessing }
FJMUModelUpdater >> fastModel [

	^ fastModel
]

{ #category : #accessing }
FJMUModelUpdater >> fastModel: anObject [

	fastModel := anObject
]

{ #category : #accessing }
FJMUModelUpdater >> fileAnchorPath [

	^ fileAnchorPath
]

{ #category : #accessing }
FJMUModelUpdater >> fileAnchorPath: anObject [

	fileAnchorPath := anObject
]

{ #category : #'model - create' }
FJMUModelUpdater >> generateAnchorBasedOn: famixSourceAnchor for: aFastJavaEntity [

	^ (self create: FamixJavaIndexedFileAnchor)
		  startPos: aFastJavaEntity startPos;
		  endPos: aFastJavaEntity endPos;
		  fileName: famixSourceAnchor;
		  yourself
]

{ #category : #accessing }
FJMUModelUpdater >> initialize [
	cleaner := FJMUModelCleaner new
]

{ #category : #'model - update' }
FJMUModelUpdater >> update [

	| mainFastClassDeclaration newlyCreatedEntity |
	mainFastClassDeclaration := (self fastModel allWithType:
		                             FASTJavaClassDeclaration) detect: [ 
		                            :classDecl | classDecl parentNode isNil ].
	self cleaner clean: famixEntity.
	newlyCreatedEntity := mainFastClassDeclaration accept: self.

	"self famixEntity sourceAnchor startPos:
		mainFastClassDeclaration startPos.
	self famixEntity sourceAnchor endPos: mainFastClassDeclaration endPos"
	^ newlyCreatedEntity
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaAnnotation: aFASTJavaAnnotation [

	(self famixModel allWithType: FamixJavaAnnotationType)
		detect: [ :famixAnnotationType | 
			famixAnnotationType name = aFASTJavaAnnotation expression name ]
		ifOne: [ :annotationType | 
			| annotationInstance |
			annotationInstance := self create: FamixJavaAnnotationInstance from: aFASTJavaAnnotation.
			annotationInstance annotationType: annotationType.
			^ annotationInstance ]
		ifNone: [ ^ nil ]
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaClassDeclaration: aFastJavaClassDeclaration [

	| famixClass |
	famixClass := self create: FamixJavaClass from: aFastJavaClassDeclaration.
	famixClass name: aFastJavaClassDeclaration name.

	(aFastJavaClassDeclaration declarations select: [ :decl | 
		 decl isKindOf: FASTJavaMethodEntity ]) do: [ :method | 
		famixClass addMethod: (method accept: self) ].
	^ famixClass
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaMethodEntity: aFastMethod [

	| famixMethod |
	famixMethod := self create: FamixJavaMethod from: aFastMethod.
	famixMethod name: aFastMethod name.
	aFastMethod parameters do: [ :fastParam | 
		famixMethod addParameter: (fastParam accept: self) ].
	aFastMethod children
		select: [ :child | child isKindOf: FASTJavaAnnotation ]
		thenDo: [ :fastAnnotation | 
			(fastAnnotation accept: self) ifNotNil: [ :annotationInstance | 
				famixMethod addAnnotationInstance: annotationInstance ] ].
	^ famixMethod
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaParameter: aFASTJavaParameter [

	| famixParam |
	famixParam := self create: FamixJavaParameter from: aFASTJavaParameter.
	famixParam name: aFASTJavaParameter variable name.
	^ famixParam
]
