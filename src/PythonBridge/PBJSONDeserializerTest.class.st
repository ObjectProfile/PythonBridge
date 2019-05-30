Class {
	#name : #PBJSONDeserializerTest,
	#superclass : #TestCase,
	#instVars : [
		'mapper'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #running }
PBJSONDeserializerTest >> application [
	^ 'FOO'
]

{ #category : #running }
PBJSONDeserializerTest >> deserialize: anObject [
	^ self deserializer deserialize: anObject
]

{ #category : #running }
PBJSONDeserializerTest >> deserializer [
	^ mapper deserializer
]

{ #category : #running }
PBJSONDeserializerTest >> setUp [
	super setUp.
	mapper := PBMapperFactory forExecutionHandler: self stubExecutionHandler
]

{ #category : #running }
PBJSONDeserializerTest >> stubExecutionHandler [
	^ PBExecutionHandler new
			application: self application;
			yourself
]

{ #category : #tests }
PBJSONDeserializerTest >> testDeserializeArray [
	self assert: (self deserialize: '[33,"foo"]') equals: #(33 'foo')
]

{ #category : #tests }
PBJSONDeserializerTest >> testDeserializeNull [
	self assert: (self deserialize: 'null') equals: nil
]

{ #category : #tests }
PBJSONDeserializerTest >> testDeserializeProxy [
	| proxy |
	proxy := self deserialize: '{"__pyclass__":"MyClass","__pyid__":"abcde12345"}'.
	self assert: proxy pythonClass equals: #MyClass.
	self assert: proxy application equals: self deserializer application.
	self assert: proxy application equals: 'FOO'.
	self assert: proxy pythonVariable equals: 'abcde12345' asP3GI
]

{ #category : #tests }
PBJSONDeserializerTest >> testDeserializeProxyInArray [
	| proxy arr |
	arr := self deserialize: '[{"__pyclass__":"MyClass","__pyid__":"abcde12345"}]'.
	self assert: arr size equals: 1.
	proxy := arr first.
	self assert: proxy pythonClass equals: #MyClass.
	self assert: proxy application equals: self deserializer application.
	self assert: proxy application equals: 'FOO'.
	self assert: proxy pythonVariable equals: 'abcde12345' asP3GI
]
