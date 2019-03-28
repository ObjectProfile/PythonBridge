Class {
	#name : #PBJSONSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'mapper'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBJSONSerializerTest >> serializer [
	^ mapper serializer
]

{ #category : #tests }
PBJSONSerializerTest >> setUp [
	super setUp.
	mapper := PBMapperFactory forExecutionHandler: self
]

{ #category : #tests }
PBJSONSerializerTest >> testSerializeArray [
	self assert: (self serializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]

{ #category : #tests }
PBJSONSerializerTest >> testSerializeNil [
	self assert: (self serializer serialize: nil) equals: 'null'
]
