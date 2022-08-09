Extension { #name : #FamixJavaClass }

{ #category : #'*FamixJavaModelUpdater' }
FamixJavaClass >> qualifiedName [

	^ String streamContents: [ :stream | self qualifiedNameOn: stream ]
]

{ #category : #'*FamixJavaModelUpdater' }
FamixJavaClass >> qualifiedNameOn: aStream [

	| parent |
	parent := (self atScope: FamixTPackage) anyOne.
	parent ifNotNil: [ 
		parent qualifiedNameOn: aStream.
		aStream
			nextPut: $. ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]
