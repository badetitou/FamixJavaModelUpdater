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
