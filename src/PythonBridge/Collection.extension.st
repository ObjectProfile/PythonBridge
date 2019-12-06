Extension { #name : #Collection }

{ #category : #'*PythonBridge' }
Collection >> ensureDo: aBlock [
	self do: [ :el | aBlock valueUninterruptably ]
]
