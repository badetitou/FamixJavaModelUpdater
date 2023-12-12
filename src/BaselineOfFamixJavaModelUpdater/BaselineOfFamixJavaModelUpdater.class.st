Class {
	#name : #BaselineOfFamixJavaModelUpdater,
	#superclass : #BaselineOf,
	#category : #BaselineOfFamixJavaModelUpdater
}

{ #category : #baselines }
BaselineOfFamixJavaModelUpdater >> baseline: spec [

	<baseline>
	self defineDependencies: spec.
	self definePackages: spec.
	self defineGroups: spec
]

{ #category : #baselines }
BaselineOfFamixJavaModelUpdater >> defineDependencies: spec [

	spec
		baseline: 'Carrefour'
		with: [ spec repository: 'github://moosetechnology/Carrefour:v4.0.2/src' ].
	spec
		baseline: 'GitBridge'
		with: [ spec repository: 'github://jecisc/GitBridge:v1.x.x/src' ]
]

{ #category : #baselines }
BaselineOfFamixJavaModelUpdater >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfFamixJavaModelUpdater >> definePackages: spec [

	spec
		package: 'FamixJavaModelUpdater'
		with: [ spec requires: #( 'Carrefour' ) ].
	spec package: 'FamixJavaModelUpdater-Tests' with: [ 
		spec requires:
			#( 'FamixJavaModelUpdater' 'FamixJavaModelUpdater-Bridge' ) ].
	spec
		package: 'FamixJavaModelUpdater-Bridge'
		with: [ spec requires: #( 'GitBridge' ) ]
]
