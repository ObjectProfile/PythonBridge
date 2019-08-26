Class {
	#name : #GTPythonVariablesBrowser,
	#superclass : #GTObjectVariablesBrowser,
	#category : #PythonPlayground
}

{ #category : #building }
GTPythonVariablesBrowser >> basicVariableNodesFor: anObject in: aCollection [
	(anObject isKindOf: PBProxyObject) 
		ifFalse: [ ^ super basicVariableNodesFor: anObject in: aCollection ].
	anObject application commandFactory << (#bridge_inspect callWith: { anObject }).
	anObject application commandFactory sendAndWait associationsDo: [ :assoc |
		aCollection add: (GTInspectorPythonIVarNode 
									hostObject: anObject 
									name: assoc key 
									pythonObject: assoc value) ].
]

{ #category : #building }
GTPythonVariablesBrowser >> childrenVariableNodesForNode: aNode [
	| variableNodes |
	variableNodes := OrderedCollection new.
	variableNodes add: (GTInspectorWrapperNode hostObject: aNode label: 'self').
	self basicVariableNodesFor: aNode value in: variableNodes.
	^ variableNodes
]

{ #category : #building }
GTPythonVariablesBrowser >> compose [
	super compose.
	self title: 'Python Raw'.
]
