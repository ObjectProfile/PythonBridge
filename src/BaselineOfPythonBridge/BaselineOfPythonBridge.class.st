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
				with: [ spec repository: 'github://pharo-contributions/OSSubprocess:v1.0.0/repository' ].
			spec
				baseline: 'Python3Generator' 
				with: [ spec repository: 'github://juliendelplanque/Python3Generator:v2.0.0/repository' ].
			spec baseline: 'NeoJSON' with: [
                spec
                    repository: 'github://svenvc/NeoJSON/repository' ].
			spec baseline: 'MessagePack' with: [
                spec
                    repository: 'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ].
			spec
				package: 'PythonBridge' with: [ spec requires: #('OSSubprocess' 'Python3Generator') ];
				package: 'PythonBridge-Pharo' with: [ spec requires: #('PythonBridge' 'MessagePack') ];
				package: 'PythonBridge-Bootstrap' with: [ spec requires: 'PythonBridge' ].
			 ]
]
