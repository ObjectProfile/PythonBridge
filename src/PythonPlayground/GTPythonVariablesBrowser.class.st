Class {
	#name : #GTPythonVariablesBrowser,
	#superclass : #GTObjectVariablesBrowser,
	#category : #PythonPlayground
}

{ #category : #building }
GTPythonVariablesBrowser >> basicVariableNodesFor: anObject in: aCollection [
	PBCF << (anObject => #__dict__).
	PBCF sendAndWait associationsDo: [ :assoc |
		aCollection add: (GTInspectorPythonIVarNode 
									hostObject: anObject 
									name: assoc key 
									pythonObject: assoc value) ].
]

{ #category : #building }
GTPythonVariablesBrowser >> compose [
	super compose.
	self title: 'Python Raw'.
]
