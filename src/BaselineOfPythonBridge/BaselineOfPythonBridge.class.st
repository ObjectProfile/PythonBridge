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
				baseline: 'OSSubprocess' 
				with: [ spec repository: 'github://pharo-contributions/OSSubprocess:v0.1.4/repository' ].
			spec
				baseline: 'Python3Generator' 
				with: [ spec repository: 'github://juliendelplanque/Python3Generator:v1.0.0/repository' ].
			spec
				package: 'PythonBridge' with: [ spec requires: 'OSSubprocess' ]
			 ]
]
