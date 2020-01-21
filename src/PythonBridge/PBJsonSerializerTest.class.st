Class {
	#name : #PBJsonSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #testing }
PBJsonSerializerTest class >> isAbstract [
	^ self == PBJsonSerializerTest
]

{ #category : #asserting }
PBJsonSerializerTest >> assertDeserialize: aString equals: anObject [
	self assert: (serializer deserialize: aString) equals: anObject
]

{ #category : #asserting }
PBJsonSerializerTest >> assertSerialize: anObject equals: aString [
	self assert: (serializer serialize: anObject) equals: aString
]

{ #category : #running }
PBJsonSerializerTest >> jsonSerializerClass [
	self subclassResponsibility
]

{ #category : #running }
PBJsonSerializerTest >> setUp [
	super setUp.
	serializer := self jsonSerializerClass new
]

{ #category : #tests }
PBJsonSerializerTest >> testDeserializeArray [
	self assertDeserialize: '[33,"foo"]' equals: #(33 'foo')
]

{ #category : #tests }
PBJsonSerializerTest >> testDeserializeNestedArrays [
	self assertDeserialize: '[33,["foo","bar"]]' equals: #(33 #('foo' 'bar'))
]

{ #category : #tests }
PBJsonSerializerTest >> testDeserializeNil [
	self assertDeserialize: 'null' equals: nil
]

{ #category : #tests }
PBJsonSerializerTest >> testSerializeArray [
	self assertSerialize: #(33 'foo') equals: '[33,"foo"]'
]

{ #category : #tests }
PBJsonSerializerTest >> testSerializeNestedArrays [
	self assertSerialize: #(33 #('foo' 'bar')) equals: '[33,["foo","bar"]]'
]

{ #category : #tests }
PBJsonSerializerTest >> testSerializeNil [
	self assertSerialize: nil equals: 'null'
]
