Class {
	#name : #PBJSONSerializer,
	#superclass : #TestCase,
	#instVars : [
		'mapper'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBJSONSerializer >> serializer [
	^ mapper serializer
]

{ #category : #tests }
PBJSONSerializer >> setUp [
	super setUp.
	mapper := PBMapperFactory forApplication: self
]

{ #category : #tests }
PBJSONSerializer >> testSerializeArray [
	self assert: (self serializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]

{ #category : #tests }
PBJSONSerializer >> testSerializeNil [
	self assert: (self serializer serialize: nil) equals: 'null'
]
