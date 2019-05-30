Extension { #name : #PBProxyObject }

{ #category : #'*PythonPlayground' }
PBProxyObject >> gtPythonInspectorIn: composite [
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: -10>
	<gtInspectorTag: #basic>
	^ composite custom: GTPythonVariablesBrowser new
]
