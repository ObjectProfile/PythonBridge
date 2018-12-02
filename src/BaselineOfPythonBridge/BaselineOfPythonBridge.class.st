Class {
	#name : #BaselineOfPythonBridge,
	#superclass : #BaselineOf,
	#category : #BaselineOfPythonBridge
}

{ #category : #baselines }
BaselineOfPythonBridge >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [			
			spec
				package: 'PythonBridge'.
				
			spec group: 'default' with: #('PythonBridge').
			spec group: 'Tests' with: #('PythonBridge' ) ]
]
