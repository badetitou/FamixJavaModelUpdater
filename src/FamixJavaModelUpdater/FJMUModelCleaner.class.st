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

{ #category : #api }
FJMUModelCleaner >> visitClass: aFamixJavaClass [

	aFamixJavaClass methods copy do: [ :m | m parentType: nil ]
]

{ #category : #api }
FJMUModelCleaner >> visitEntity: aFamixJavaEntity [
	^ nil
]
