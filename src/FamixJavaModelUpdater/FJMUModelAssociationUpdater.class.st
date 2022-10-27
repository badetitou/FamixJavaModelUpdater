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
FJMUModelAssociationUpdater >> visitFASTJavaClassDeclaration: aFASTJavaClassDeclaration [

	"resolve declaredType"

	famixEntity ifNotNil: [ :originalFamixEntity | 
		originalFamixEntity typedEntities copy do: [ :typedEntity | 
			typedEntity declaredType:
				aFASTJavaClassDeclaration famixTypeDefinition ] ].
	super visitFASTJavaClassDeclaration: aFASTJavaClassDeclaration
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
FJMUModelAssociationUpdater >> visitFASTJavaMethodInvocation: aFASTJavaMethodInvocation [

	| famixJavaInvocation parentBehavior |
	famixJavaInvocation := self
		                       create: FamixJavaInvocation
		                       from: aFASTJavaMethodInvocation.
	famixJavaInvocation signature:
		(aFASTJavaMethodInvocation rootNode sourceText
			 copyFrom: aFASTJavaMethodInvocation startPos
			 to: aFASTJavaMethodInvocation endPos).
	parentBehavior := self resolveFamixScopeContainerOf:
		                  aFASTJavaMethodInvocation.
	famixJavaInvocation sender: parentBehavior.
	aFASTJavaMethodInvocation receiver
		ifNotNil: [ :fastInvocationReceiver | 
			fastInvocationReceiver famixVariable ifNotNil: [ :famixVariable | 
				famixJavaInvocation receiver: famixVariable ] ]
		ifNil: [ 
			| anImplicitSelf |
			anImplicitSelf := self create: FamixJavaImplicitVariable.
			famixJavaInvocation receiver: anImplicitSelf.
			anImplicitSelf parentBehaviouralEntity: parentBehavior ].
	((famixJavaInvocation receiver isKindOf: FamixJavaImplicitVariable)
		 ifTrue: [ 
		 (famixJavaInvocation receiver atScope: FamixTClass) anyOne ]
		 ifFalse: [ famixJavaInvocation receiver declaredType ]) ifNotNil: [ 
		:candidate | 
		| candidateClass |
		candidateClass := (candidate isKindOf: FamixJavaParameterizedType)
			                  ifTrue: [ candidate parameterizableClass ]
			                  ifFalse: [ candidate ].
		candidateClass ifNotNil: [ :notNilCandidateClass | 
			notNilCandidateClass allMethods
				detect: [ :m | m name = aFASTJavaMethodInvocation name ]
				ifOne: [ :candidateMethod | 
					famixJavaInvocation addCandidate: candidateMethod ] ] ].

	aFASTJavaMethodInvocation famixInvocation: famixJavaInvocation.
	^ famixJavaInvocation
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
