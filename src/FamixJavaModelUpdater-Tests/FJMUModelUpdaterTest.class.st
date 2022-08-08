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

{ #category : #tests }
FJMUModelUpdaterTest >> testVisitFASTClassWithAttributes [

	| fastClassDeclaration |
	fastClassDeclaration := ((JavaSmaCCProgramNodeImporterVisitor new 
		                          parseCodeString: 'class A {
    int i = 0;
	 boolean b = false;
}') allWithType: FASTJavaClassDeclaration) anyOne.
	fastClassDeclaration accept: modelUpdater.
	self
		assert: (famixModel allWithType: FamixJavaClass) size
		equals: 1.
	self
		assert: (famixModel allWithType: FamixJavaAttribute) size
		equals: 2
]

{ #category : #tests }
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

{ #category : #test }
FJMUModelUpdaterTest >> testVisitFASTJavaClassDeclaration [

	| fastClassDeclaration |
	fastClassDeclaration := FASTJavaClassDeclaration new.
	fastClassDeclaration
		name: 'MyClass';
		yourself.
	fastClassDeclaration accept: modelUpdater.
	self assert: (famixModel allWithType: FamixJavaClass) size equals: 1.
	self
		assert: (famixModel allWithType: FamixJavaClass) anyOne name
		equals: 'MyClass'
]

{ #category : #tests }
FJMUModelUpdaterTest >> testVisitFASTJavaMethodEntity [

	| fastMethod |
	fastMethod := FASTJavaMethodEntity new.
	fastMethod name: 'methodName'.
	fastMethod accept: modelUpdater.
	self assert: famixModel anyOne class equals: FamixJavaMethod.
	self assert: famixModel anyOne name equals: 'methodName'
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

{ #category : #tests }
FJMUModelUpdaterTest >> testVisitFASTJavaVariableDeclarator [

	| fasVariableDeclarator |
	fasVariableDeclarator := FASTJavaVariableDeclarator new.
	fasVariableDeclarator variable: (FASTJavaVariableExpression new
			 name: 'variableName';
			 yourself).
	fasVariableDeclarator accept: modelUpdater.
	self
		assert: (famixModel allWithType: FamixJavaAttribute) size
		equals: 1.
	self
		assert: (famixModel allWithType: FamixJavaAttribute) anyOne name
		equals: 'variableName'
]
