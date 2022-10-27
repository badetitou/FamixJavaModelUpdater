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
			(decl accept: self) ] ].

	aFastJavaClassDeclaration superclass ifNotNil: [ :superclass | 
		(aFastJavaClassDeclaration mooseModel allWithType:
			 FASTJavaImportDeclaration)
			detect: [ :importDeclaration | 
				importDeclaration declarationName name = superclass typeName name ]
			ifOne: [ :importDeclaration | 
				famixClass mooseModel allPackages
					detect: [ :pa | 
						pa qualifiedName
						= importDeclaration declarationName namespace fullName ]
					ifOne: [ :package | 
						package types
							detect: [ :type | type name = superclass typeName name ]
							ifOne: [ :type | 
								(self create: FamixJavaInheritance)
									subclass: famixClass;
									superclass: type ] ] ]
			ifNone: [ 
				famixClass mooseModel allModelClasses asOrderedCollection
					detect: [ :class | class name = superclass typeName name ]
					ifOne: [ :class | 
						(self create: FamixJavaInheritance)
							subclass: famixClass;
							superclass: class ] ] ].
	aFastJavaClassDeclaration interfaces do: [ :interface | 
		(self retrieveClassFromModel: interface typeName name) ifNotNil: [ 
			:famixInterface | 
			(self create: FamixJavaImplementation)
				implementingClass: famixClass;
				interface: famixInterface ] ].
	^ famixClass
]

{ #category : #'model - update' }
FJMUModelUpdater >> visitFASTJavaMethodEntity: aFastMethod [

	| famixMethod |
	famixMethod := self create: FamixJavaMethod from: aFastMethod.
	aFastMethod famixMethod: famixMethod.
	famixMethod name: aFastMethod name.
	aFastMethod parameters do: [ :fastParam | 
		famixMethod addParameter: (fastParam accept: self) ].
	aFastMethod children
		select: [ :child | child isKindOf: FASTJavaAnnotation ]
		thenDo: [ :fastAnnotation | 
			(fastAnnotation accept: self) ifNotNil: [ :annotationInstance | 
				famixMethod addAnnotationInstance: annotationInstance ] ].
	aFastMethod throws do: [ :throw | 
		(self retrieveClassFromModel: throw typeName name) ifNotNil: [ 
			:aClass | 
			(self create: FamixJavaDeclaredException)
				definingEntity: famixMethod;
				exceptionClass: aClass ] ].
	aFastMethod statements do: [ :statement | statement accept: self ].

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

	| famixVariable scope |
	scope := self fastScopeOwnerOf: aFASTJavaVariableDeclarator.
	famixVariable := (scope isKindOf: FASTJavaMethodEntity)
		                 ifTrue: [ 
			                 self
				                 create: FamixJavaLocalVariable
				                 from: aFASTJavaVariableDeclarator ]
		                 ifFalse: [ 
		                 self
			                 create: FamixJavaAttribute
			                 from: aFASTJavaVariableDeclarator ].
	famixVariable name: aFASTJavaVariableDeclarator variable name.
	(aFASTJavaVariableDeclarator atScope: FASTJavaVarDeclStatement)
		anyOne modifiers do: [ :modifier | 
		modifier token = 'public' ifTrue: [ famixVariable isPublic: true ].
		modifier token = 'final' ifTrue: [ famixVariable isFinal: true ].
		modifier token = 'static' ifTrue: [ famixVariable isClassSide: true ] ].
	(aFASTJavaVariableDeclarator varDeclOwner type isKindOf:
		 FASTJavaClassTypeExpression) ifTrue: [ 
		(self retrieveClassFromModel:
			 aFASTJavaVariableDeclarator varDeclOwner type typeName name) 
			ifNotNil: [ :type | famixVariable declaredType: type ] ].
	(scope isKindOf: FASTJavaMethodEntity)
		ifTrue: [ scope famixMethod addLocalVariable: famixVariable ]
		ifFalse: [ scope famixTypeDefinition addAttribute: famixVariable ]
]
