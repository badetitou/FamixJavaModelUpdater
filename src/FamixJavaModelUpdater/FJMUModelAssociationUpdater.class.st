"
I resolve the associations between elements: 

For instance, I resolve:

- access
- invocation
"
Class {
	#name : #FJMUModelAssociationUpdater,
	#superclass : #FASTJavaVisitor,
	#traits : 'TFJMUEntityFactory',
	#classTraits : 'TFJMUEntityFactory classTrait',
	#instVars : [
		'fastModel',
		'newFamixEntity',
		'famixEntity'
	],
	#category : #'FamixJavaModelUpdater-Updater'
}

{ #category : #accessing }
FJMUModelAssociationUpdater >> famixEntity [

	^ famixEntity
]

{ #category : #accessing }
FJMUModelAssociationUpdater >> famixEntity: anObject [

	famixEntity := anObject
]

{ #category : #accessing }
FJMUModelAssociationUpdater >> fastModel [

	^ fastModel
]

{ #category : #accessing }
FJMUModelAssociationUpdater >> fastModel: anObject [

	fastModel := anObject
]

{ #category : #accessing }
FJMUModelAssociationUpdater >> newFamixEntity [

	^ newFamixEntity
]

{ #category : #accessing }
FJMUModelAssociationUpdater >> newFamixEntity: anObject [

	newFamixEntity := anObject
]

{ #category : #'model - update' }
FJMUModelAssociationUpdater >> resolveFamixScopeContainerOf: aFASTEntity [

	| scope |
	scope := (aFASTEntity atAnyScope: { 
			          FASTJavaClassDeclaration.
			          FASTJavaMethodEntity }) anyOne.
	(scope isKindOf: FASTJavaMethodEntity) ifTrue: [ ^ scope famixMethod ]
]

{ #category : #'model - update' }
FJMUModelAssociationUpdater >> update [

	| mainFastClassDeclaration |
	mainFastClassDeclaration := (self fastModel allWithType:
		                             FASTJavaClassDeclaration) detect: [ 
		                            :classDecl | classDecl parentNode isNil ].
	self newFamixEntity
		bindFastModel: self fastModel
		usingBinder: CRFBinderVisitor new.
	mainFastClassDeclaration accept: self
]

{ #category : #'model - update' }
FJMUModelAssociationUpdater >> visitFASTJavaFieldAccess: aFASTJavaFieldAccess [

	aFASTJavaFieldAccess famixVariable ifNotNil: [ :famixVariable | 
		| famixAccess |
		famixAccess := self
			               create: FamixJavaAccess
			               from: aFASTJavaFieldAccess.
		famixAccess variable: famixVariable.
		famixAccess accessor:
			(self resolveFamixScopeContainerOf: aFASTJavaFieldAccess) ]
]

{ #category : #'model - update' }
FJMUModelAssociationUpdater >> visitFASTJavaTypeExpression: aFASTJavaTypeExpression [
	self flag: #'Not supported yet'
]

{ #category : #'model - update' }
FJMUModelAssociationUpdater >> visitFASTTVariableExpression: aFASTVariableExpression [

	(aFASTVariableExpression parentNode isKindOf:
		 FASTJavaVariableDeclarator) ifTrue: [ ^ self ].

	aFASTVariableExpression famixVariable ifNotNil: [ :famixVariable | 
		| famixAccess |
		famixAccess := self
			               create: FamixJavaAccess
			               from: aFASTVariableExpression.
		famixAccess variable: famixVariable.
		famixAccess accessor: (self resolveFamixScopeContainerOf: aFASTVariableExpression) ]
]
