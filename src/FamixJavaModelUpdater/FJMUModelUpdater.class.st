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
	#superclass : #Object,
	#instVars : [
		'fastModel',
		'famixModel',
		'famixEntity'
	],
	#category : #FamixJavaModelUpdater
}

{ #category : #'model - update' }
FJMUModelUpdater >> addMissingMethods [

	self famixEntity methods copy do: [:m | m parentType: nil].
	(self fastModel allWithType: FASTJavaMethodEntity) do: [ :method |
		self famixEntity addMethod:
			(self createFamixMethodFromFastMethod: method) ].


]

{ #category : #'model - update' }
FJMUModelUpdater >> create: aFamixClass [

	^ self famixModel add: aFamixClass new
]

{ #category : #'model - update' }
FJMUModelUpdater >> createFamixAnnotationInstanceFromFastAnnotation: fastAnnotation [

	(self famixModel allWithType: FamixJavaAnnotationType)
		detect: [ :famixAnnotationType | 
			famixAnnotationType name = fastAnnotation expression name ]
		ifOne: [ :annotationType | 
			| annotationInstance |
			annotationInstance := self create: FamixJavaAnnotationInstance.
			annotationInstance annotationType: annotationType.
			^ annotationInstance ]
		ifNone: [ ^ nil ]
]

{ #category : #'model - update' }
FJMUModelUpdater >> createFamixMethodFromFastMethod: aFastMethod [

	| famixMethod |
	famixMethod := self create: FamixJavaMethod.
	famixMethod name: aFastMethod name.
	aFastMethod parameters do: [ :fastParam | 
		famixMethod addParameter:
			(self createFamixParameterFromFastParameter: fastParam) ].
	aFastMethod children
		select: [ :child | child isKindOf: FASTJavaAnnotation ]
		thenDo: [ :fastAnnotation | 
			(self createFamixAnnotationInstanceFromFastAnnotation:
				 fastAnnotation) ifNotNil: [ :annotationInstance | 
				famixMethod addAnnotationInstance: annotationInstance ] ].
	^ famixMethod
]

{ #category : #'model - update' }
FJMUModelUpdater >> createFamixParameterFromFastParameter: fastParam [

	| famixParam |
	famixParam := self create: FamixJavaParameter.
	famixParam name: fastParam variable name.
	^ famixParam
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

{ #category : #'model - update' }
FJMUModelUpdater >> update [
	self addMissingMethods.
	self famixEntity sourceAnchor startPos: (self fastModel allWithType: FASTJavaClassDeclaration) anyOne startPos.
	self famixEntity sourceAnchor endPos: (self fastModel allWithType: FASTJavaClassDeclaration) anyOne endPos.
]
