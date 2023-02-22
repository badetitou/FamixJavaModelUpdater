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

	spec baseline: 'FASTJava' with: [ 
		spec
			loads: #( 'smacc' 'visitor' );
			repository: 'github://moosetechnology/FAST-Java:v3/src' ].
	spec
		baseline: 'Carrefour'
		with: [ spec repository: 'github://badetitou/Carrefour:v4/src' ].
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
		with: [ spec requires: #( 'FASTJava' 'Carrefour' ) ].
	spec package: 'FamixJavaModelUpdater-Tests' with: [ 
		spec requires:
			#( 'FamixJavaModelUpdater' 'FamixJavaModelUpdater-Bridge' ) ].
	spec
		package: 'FamixJavaModelUpdater-Bridge'
		with: [ spec requires: #( 'GitBridge' ) ]
]
