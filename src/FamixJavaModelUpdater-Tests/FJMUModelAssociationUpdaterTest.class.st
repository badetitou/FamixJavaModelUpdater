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

{ #category : #running }
FJMUModelAssociationUpdaterTest >> setUp [

	modelUpdater := FJMUModelUpdater new.
	famixModel := FamixJavaModel new.
	modelUpdater famixModel: famixModel
]

{ #category : #tests }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaClassDeclarationDeclaredTypeMethod [

	| externalFamixClass externalFamixMethod myClass fastClassDeclaration newlyCreatedFamixEntity |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	externalFamixClass := famixModel allModelClasses detect: [ :c | 
		                      c name = 'ExternalFamixJavaClass' ].
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].
	externalFamixMethod := famixModel allModelMethods detect: [ :c | 
		                       c name = 'externalFamixJavaMethod' ].
	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.

	self
		assert: externalFamixMethod declaredType
		equals: newlyCreatedFamixEntity
]

{ #category : #tests }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaClassDeclarationParentTypeMethod [

	| externalFamixMethod myClass fastClassDeclaration newlyCreatedFamixEntity externalFamixClass |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].
	externalFamixClass := famixModel allModelClasses detect: [ :c | 
		                      c name = 'ExternalFamixJavaClass' ].
	externalFamixMethod := famixModel allModelMethods detect: [ :c | 
		                       c name = 'methodM' ].
	fastClassDeclaration := JavaSmaCCProgramNodeImporterVisitor new 
		                        parseCodeString:
		                        myClass sourceAnchor completeText.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.

	self assert: externalFamixMethod parentType equals: nil.
	self
		assert:
			(newlyCreatedFamixEntity methods detect: [ :m | m name = 'methodM' ])
				parentType
		equals: newlyCreatedFamixEntity.
	self
		assert:
			(newlyCreatedFamixEntity methods detect: [ :m | m name = 'methodM' ])
				declaredType
		equals: externalFamixClass
]

{ #category : #tests }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaClassDeclarationThrownException [

	| originalExceptionClass method myClass fastClassDeclaration newlyCreatedFamixEntity |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	originalExceptionClass := famixModel allModelClasses detect: [ :c | 
		                          c name = 'MyException' ].
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].
	method := famixModel allModelMethods detect: [ :c | 
		          c name = 'methodM' ].
	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	self
		assert: method declaredExceptions anyOne
		equals:
			(newlyCreatedFamixEntity methods detect: [ :m | m name = 'methodM' ])
				declaredExceptions anyOne
]

{ #category : #tests }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaFieldAccess [

	| fastClassDeclaration famixAccess |
	fastClassDeclaration := JavaSmaCCProgramNodeImporterVisitor new 
		                        parseCodeString: 'class A {
    int i = 0;

	void methodM() { 
		this.i++;
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

{ #category : #tests }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaMethodInvocation [

	| externalFamixJavaClass externalFamixJavaClassMethod myClass newMethod fastClassDeclaration newlyCreatedFamixEntity myExternalFamixJavaClassVariable |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	externalFamixJavaClass := famixModel allModelClasses detect: [ :c | 
		                          c name = 'ExternalFamixJavaClass' ].
	externalFamixJavaClassMethod := externalFamixJavaClass methods 
		                                detect: [ :method | 
		                                method name
		                                = 'externalFamixJavaMethod' ].
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].

	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	newMethod := famixModel allModelMethods detect: [ :c | 
		             c name = 'aMethodWithInvocation' ].
	myExternalFamixJavaClassVariable := (famixModel allWithType:
		                                     FamixJavaLocalVariable) 
		                                    detect: [ :c | 
		                                    c name
		                                    = 'myExternalFamixJavaClass' ].
	"assertequals: 1 because the Call to the constructor is not yet supported"
	self assert: newMethod queryAllOutgoingInvocations size equals: 1.
	self
		assert: newMethod queryAllOutgoingInvocations anyOne sender
		equals: newMethod.
	self
		assert: newMethod queryAllOutgoingInvocations anyOne receiver
		equals: myExternalFamixJavaClassVariable.
	self
		assert:
		newMethod queryAllOutgoingInvocations anyOne candidates anyOne
		equals: externalFamixJavaClassMethod
]

{ #category : #'as yet unclassified' }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaParametrizedTypeMethodInvocation [

	| parameterizedType parameterizedClassMethod myClass newMethod fastClassDeclaration newlyCreatedFamixEntity |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	parameterizedType := (famixModel allWithType: FamixJavaParameterizableClass) detect: [ :c | 
		                          c name = 'MyParametrizable' ].
	parameterizedClassMethod := parameterizedType methods 
		                                detect: [ :method | 
		                                method name
		                                = 'myMethod' ].
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].

	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	newMethod := famixModel allModelMethods detect: [ :c | 
		             c name = 'aParametrizedTypeMethodCall' ].
	"assertequals: 1 because the Call to the constructor is not yet supported"
	self assert: newMethod queryAllOutgoingInvocations size equals: 1.
	self
		assert: newMethod queryAllOutgoingInvocations anyOne sender
		equals: newMethod.
	self
		assert:
		newMethod queryAllOutgoingInvocations anyOne candidates anyOne
		equals: parameterizedClassMethod
]

{ #category : #tests }
FJMUModelAssociationUpdaterTest >> testVisitFASTJavaSuperMethodInvocation [

	| externalFamixJavaClass externalFamixJavaClassMethod myClass newMethod fastClassDeclaration newlyCreatedFamixEntity myExternalFamixJavaClassVariable |
	FJMUBridge testsResources / 'output.json' readStreamDo: [ :stream | 
		famixModel importFromJSONStream: stream ].
	famixModel rootFolder: FJMUBridge testsResources pathString.
	externalFamixJavaClass := famixModel allModelClasses detect: [ :c | 
		                          c name = 'MySuperClass' ].
	externalFamixJavaClassMethod := externalFamixJavaClass methods 
		                                detect: [ :method | 
		                                method name
		                                = 'aSuperMethod' ].
	myClass := famixModel allModelClasses detect: [ :c | 
		           c name = 'MyClass' ].

	fastClassDeclaration := myClass generateFastJava.
	newlyCreatedFamixEntity := modelUpdater
		                           famixModel: famixModel;
		                           famixEntity: myClass;
		                           fastModel: fastClassDeclaration;
		                           update.
	newMethod := famixModel allModelMethods detect: [ :c | 
		             c name = 'aSuperMethodCall' ].
	"assertequals: 1 because the Call to the constructor is not yet supported"
	self assert: newMethod queryAllOutgoingInvocations size equals: 1.
	self
		assert: newMethod queryAllOutgoingInvocations anyOne sender
		equals: newMethod.
	self
		assert: newMethod queryAllOutgoingInvocations anyOne receiver class
		equals: FamixJavaImplicitVariable.
	self
		assert:
		newMethod queryAllOutgoingInvocations anyOne candidates anyOne
		equals: externalFamixJavaClassMethod
]

{ #category : #tests }
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
