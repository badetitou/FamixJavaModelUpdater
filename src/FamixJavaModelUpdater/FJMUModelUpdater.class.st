"
This is the main class of the FamixJava Model Updater project.

I resolves the structure of the files.
Then, it calls the association updater dedicated to resolves associations between elements

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
	#traits : 'TFJMUEntityFactory',
	#classTraits : 'TFJMUEntityFactory classTrait',
	#instVars : [
		'fastModel',
		'famixEntity',
		'cleaner'
	],
	#category : #'FamixJavaModelUpdater-Updater'
}

{ #category : #accessing }
FJMUModelUpdater >> cleaner [

	^ cleaner
]

{ #category : #accessing }
FJMUModelUpdater >> cleaner: anObject [

	cleaner := anObject
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
FJMUModelUpdater >> fastModel [

	^ fastModel
]

{ #category : #accessing }
FJMUModelUpdater >> fastModel: anObject [

	fastModel := anObject
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
	newlyCreatedEntity := mainFastClassDeclaration accept: self.

	self updateAssociationFor: newlyCreatedEntity.
	self cleaner clean: famixEntity.
	^ newlyCreatedEntity
]

{ #category : #'model - update' }
FJMUModelUpdater >> updateAssociationFor: newlyCreatedEntity [

	FJMUModelAssociationUpdater new
		famixModel: newlyCreatedEntity mooseModel;
		fastModel: self fastModel;
		famixEntity: famixEntity;
		fileAnchorPath: self fileAnchorPath;
		newFamixEntity: newlyCreatedEntity;
		update
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
	famixClass := self
		              create: FamixJavaClass
		              from: aFastJavaClassDeclaration.
	famixClass name: aFastJavaClassDeclaration name.
	famixClass fastTypeDefinition: aFastJavaClassDeclaration.

	(aFastJavaClassDeclaration declarations select: [ :decl | 
		 decl isKindOf: FASTJavaMethodEntity ]) do: [ :method | 
		famixClass addMethod: (method accept: self) ].
	(aFastJavaClassDeclaration declarations select: [ :decl | 
		 decl isKindOf: FASTJavaVarDeclStatement ]) do: [ :attributes | 
		attributes declarators do: [ :decl | 
			famixClass addAttribute: (decl accept: self) ] ].
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
	aFastMethod famixMethod: famixMethod.
	^ famixMethod
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaParameter: aFASTJavaParameter [

	| famixParam |
	famixParam := self create: FamixJavaParameter from: aFASTJavaParameter.
	famixParam name: aFASTJavaParameter variable name.
	^ famixParam
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaVariableDeclarator: aFASTJavaVariableDeclarator [

	| famixAttribute |
	famixAttribute := self
		                  create: FamixJavaAttribute
		                  from: aFASTJavaVariableDeclarator.
	famixAttribute name: aFASTJavaVariableDeclarator variable name.
	^ famixAttribute
]
