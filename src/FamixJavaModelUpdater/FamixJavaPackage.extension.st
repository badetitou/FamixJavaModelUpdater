Extension { #name : #FamixJavaPackage }

{ #category : #'*FamixJavaModelUpdater' }
FamixJavaPackage >> qualifiedName [

	^ String streamContents: [ :stream | self qualifiedNameOn: stream ]
]

{ #category : #'*FamixJavaModelUpdater' }
FamixJavaPackage >> qualifiedNameOn: aStream [

	| parent |
	parent := self belongsTo.
	parent ifNotNil: [ 
		parent qualifiedNameOn: aStream.
		aStream
			nextPut: $. ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]
