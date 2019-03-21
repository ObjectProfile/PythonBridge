Class {
	#name : #PBJSONDeserializer,
	#superclass : #TestCase,
	#instVars : [
		'mapper'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #running }
PBJSONDeserializer >> deserialize: anObject [
	^ self deserializer deserialize: anObject
]

{ #category : #running }
PBJSONDeserializer >> deserializer [
	^ mapper deserializer
]

{ #category : #running }
PBJSONDeserializer >> setUp [
	super setUp.
	mapper := PBMapperFactory forApplication: self
]

{ #category : #tests }
PBJSONDeserializer >> testDeserializeArray [
	self assert: (self deserialize: '[33,"foo"]') equals: #(33 'foo')
]

{ #category : #tests }
PBJSONDeserializer >> testDeserializeNull [
	self assert: (self deserialize: 'null') equals: nil
]

{ #category : #tests }
PBJSONDeserializer >> testDeserializeProxy [
	| proxy |
	proxy := self deserialize: '{"__pyclass__":"MyClass","__pyid__":"abcde12345"}'.
	self assert: proxy pythonClass equals: #MyClass.
	self assert: proxy application equals: self deserializer application.
	self assert: proxy pythonVariable equals: 'abcde12345' asP3GI
]
