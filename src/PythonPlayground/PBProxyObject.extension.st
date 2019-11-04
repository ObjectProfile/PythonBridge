Extension { #name : #PBProxyObject }

{ #category : #'*PythonPlayground' }
PBProxyObject >> gtProxyPythonInspectorIn: composite [
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: -10>
	^ composite custom: GTPythonVariablesBrowser new
]
