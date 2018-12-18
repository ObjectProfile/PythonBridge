Class {
	#name : #PBJSONSerializer,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBJSONSerializer >> testSerializeArray [
	self assert: (PBSerializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]
