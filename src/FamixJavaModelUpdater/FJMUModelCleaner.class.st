Class {
	#name : #FJMUModelCleaner,
	#superclass : #Object,
	#traits : 'FamixJavaVisitor',
	#classTraits : 'FamixJavaVisitor classTrait',
	#instVars : [
		'famixEntity'
	],
	#category : #'FamixJavaModelUpdater-Cleaner'
}

{ #category : #api }
FJMUModelCleaner >> clean: aFamixEntity [

	aFamixEntity ifNotNil: [ 
		famixEntity := aFamixEntity.
		aFamixEntity accept: self ]
]

{ #category : #visiting }
FJMUModelCleaner >> visitAttribute: aFamixJavaAttribute [

	aFamixJavaAttribute mooseModel ifNotNil: [ aFamixJavaAttribute mooseModel remove: aFamixJavaAttribute ]
]

{ #category : #api }
FJMUModelCleaner >> visitClass: aFamixJavaClass [

	aFamixJavaClass methods copy do: [ :m | 
		m parentType: nil.
		m accept: self ].
	aFamixJavaClass attributes copy do: [ :att | 
		att parentType: nil.
		att accept: self ].
	aFamixJavaClass mooseModel ifNotNil: [ 
		aFamixJavaClass mooseModel remove: aFamixJavaClass ]
]

{ #category : #api }
FJMUModelCleaner >> visitEntity: aFamixJavaEntity [
	^ nil
]

{ #category : #visiting }
FJMUModelCleaner >> visitMethod: aFamixJavaMethod [

	aFamixJavaMethod mooseModel ifNotNil: [ aFamixJavaMethod mooseModel remove: aFamixJavaMethod ]
]
