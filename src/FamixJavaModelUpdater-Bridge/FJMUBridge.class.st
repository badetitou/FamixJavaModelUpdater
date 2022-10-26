Class {
	#name : #FJMUBridge,
	#superclass : #GitBridge,
	#category : #'FamixJavaModelUpdater-Bridge'
}

{ #category : #initialization }
FJMUBridge class >> initialize [
    SessionManager default registerSystemClassNamed: self name

]

{ #category : #initialization }
FJMUBridge class >> testsResources [
    ^ self root / 'tests'
]
