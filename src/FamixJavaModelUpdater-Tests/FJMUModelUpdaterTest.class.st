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
	#category : #'FamixJavaModelUpdater-Tests-Updater'
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
FJMUModelUpdaterTest >> testVisitFASTClassWithAttributesAndModifiers [

	| fastClassDeclaration |
	fastClassDeclaration := ((JavaSmaCCProgramNodeImporterVisitor new 
		                          parseCodeString: 'class A {
    public int i = 0;
	 static boolean b = false;
}') allWithType: FASTJavaClassDeclaration) anyOne.
	fastClassDeclaration accept: modelUpdater.
	self assert: (famixModel allWithType: FamixJavaClass) size equals: 1.
	self
		assert: (famixModel allWithType: FamixJavaAttribute) size
		equals: 2.
	self assert:
		((famixModel allWithType: FamixJavaAttribute) detect: [ :att | 
			 att name = 'i' ]) isPublic.
	self assert:
		((famixModel allWithType: FamixJavaAttribute) detect: [ :att | 
			 att name = 'b' ]) isClassSide
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

{ #category : #tests }
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
FJMUModelUpdaterTest >> testVisitFASTJavaClassDeclarationInterface [

	| originalInterface myClass fastClassDeclaration newlyCreatedFamixEntity |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	originalInterface := (famixModel allWithType: FamixJavaInterface) detect: [ :c | 
		                          c name = 'MyInterface' ].
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].
	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	self
		assert: newlyCreatedFamixEntity interfaceImplementations anyOne interface
		equals: originalInterface
]

{ #category : #tests }
FJMUModelUpdaterTest >> testVisitFASTJavaLocalVariable [

	| myClass fastClassDeclaration newlyCreatedFamixEntity |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.

	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].
	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	self
		assert:
			(newlyCreatedFamixEntity methods detect: [ :m | m name = 'aMethod' ])
				localVariables size
		equals: 2
]

{ #category : #tests }
FJMUModelUpdaterTest >> testVisitFASTJavaLocalVariableDeclaredType [

	| myClass fastClassDeclaration newlyCreatedFamixEntity |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.

	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].
	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	self
		assert: (newlyCreatedFamixEntity methods detect: [ :m | 
				 m name = 'aMethodWithInvocation' ]) localVariables anyOne
				declaredType
		equals: (famixModel allModelClasses detect: [ :c | 
				 c name = 'ExternalFamixJavaClass' ])
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

	| fasVariableDeclarator fastVarDeclStatement fastClassDeclaration fastJavaModel famixClass |
	fastJavaModel := FASTJavaModel new.
	fastClassDeclaration := FASTJavaClassDeclaration new.
	fastVarDeclStatement := FASTJavaVarDeclStatement new.
	fastClassDeclaration addDeclaration: fastVarDeclStatement.
	fasVariableDeclarator := FASTJavaVariableDeclarator new.
	famixClass := FamixJavaClass new.
	fastClassDeclaration famixTypeDefinition: famixClass.
	famixModel add: famixClass.
	fasVariableDeclarator variable: (FASTJavaVariableExpression new
			 name: 'variableName';
			 yourself).
	fastVarDeclStatement addDeclarator: fasVariableDeclarator.
	fastJavaModel addAll: { fastClassDeclaration. fastVarDeclStatement. fasVariableDeclarator }.
	fasVariableDeclarator accept: modelUpdater.
	self
		assert: (famixModel allWithType: FamixJavaAttribute) size
		equals: 1.
	self
		assert: (famixModel allWithType: FamixJavaAttribute) anyOne name
		equals: 'variableName'
]
