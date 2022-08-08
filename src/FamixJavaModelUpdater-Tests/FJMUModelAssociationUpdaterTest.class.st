"
A FJMUModelAssociationUpdaterTest is a test class for testing the behavior of FJMUModelAssociationUpdater
"
Class {
	#name : #FJMUModelAssociationUpdaterTest,
	#superclass : #TestCase,
	#instVars : [
		'modelUpdater',
		'famixModel'
	],
	#category : #'FamixJavaModelUpdater-Tests-Updater'
}

{ #category : #test }
FJMUModelAssociationUpdaterTest >> setUp [

	modelUpdater := FJMUModelUpdater new.
	famixModel := FamixJavaModel new.
	modelUpdater famixModel: famixModel
]

{ #category : #test }
FJMUModelAssociationUpdaterTest >> testVisitFASTTVariableExpression [

	| fastClassDeclaration famixAccess |
	fastClassDeclaration := JavaSmaCCProgramNodeImporterVisitor new 
		                        parseCodeString: 'class A {
    int i = 0;

	void methodM() { 
		++i;
	}
}'.
	modelUpdater
		famixModel: famixModel;
		fastModel: fastClassDeclaration;
		update.
	self assert: (famixModel allWithType: FamixJavaAccess) size equals: 1.
	famixAccess := (famixModel allWithType: FamixJavaAccess) anyOne.
	self assert: famixAccess accessor name equals: 'methodM'.
	self assert: famixAccess variable name equals: 'i'
]
