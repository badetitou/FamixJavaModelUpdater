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
			repository: 'github://moosetechnology/FAST-Java:v2/src' ]
]

{ #category : #baselines }
BaselineOfFamixJavaModelUpdater >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfFamixJavaModelUpdater >> definePackages: spec [

	spec
		package: 'FamixJavaModelUpdater'
		with: [ spec requires: #( 'FASTJava' ) ].
	spec
		package: 'FamixJavaModelUpdater-Tests'
		with: [ spec requires: #( 'FamixJavaModelUpdater' ) ]
]
