"
A FJMUModelUpdaterTest is a test class for testing the behavior of FJMUModelUpdater
"
Class {
	#name : #FJMUModelUpdaterTest,
	#superclass : #TestCase,
	#instVars : [
		'modelUpdater',
		'famixModel'
	],
	#category : #'FamixJavaModelUpdater-Tests'
}

{ #category : #running }
FJMUModelUpdaterTest >> setUp [

	modelUpdater := FJMUModelUpdater new.
	famixModel := FamixJavaModel new.
	modelUpdater famixModel: famixModel
]

{ #category : #test }
FJMUModelUpdaterTest >> testVisitFASTJavaAnnotation [

	| fastParameter famixAnnotationType |
	fastParameter := FASTJavaAnnotation new.
	fastParameter expression: (FASTJavaVariableExpression new
			 name: 'AnnotationName';
			 yourself).
	famixAnnotationType := FamixJavaAnnotationType new
		                       name: 'AnnotationName';
		                       yourself.
	famixModel add: famixAnnotationType.
	fastParameter accept: modelUpdater.
	self
		assert: (famixModel allWithType: FamixJavaAnnotationInstance) size
		equals: 1.
	self
		assert:
			(famixModel allWithType: FamixJavaAnnotationInstance) anyOne
				annotationType
		equals: famixAnnotationType
]

{ #category : #tests }
FJMUModelUpdaterTest >> testVisitFASTJavaParameter [

	| fastParameter |
	fastParameter := FASTJavaParameter new.
	fastParameter variable: (FASTJavaVariableExpression new
			 name: 'variableName';
			 yourself).
	fastParameter accept: modelUpdater.
	self assert: famixModel anyOne class equals: FamixJavaParameter.
	self assert: famixModel anyOne name equals: 'variableName'
]