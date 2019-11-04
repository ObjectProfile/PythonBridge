Extension { #name : #PBObject }

{ #category : #'*PythonPlayground' }
PBObject >> gtPythonInspectorIn: composite [
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: 10>
	<gtInspectorTag: #basic>
	^ composite 
		custom: (GTPythonVariablesBrowser new
						when: [ :each | (each isKindOf: PBProxyObject) not ];
						yourself)
]
