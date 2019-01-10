Class {
	#name : #PBJSONSerializer,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBJSONSerializer >> testSerializeArray [
	self assert: (PBSerializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]

{ #category : #tests }
PBJSONSerializer >> testSerializeNil [
	self assert: (PBSerializer serialize: nil) equals: 'null'
]
