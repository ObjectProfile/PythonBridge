Class {
	#name : #PBMsgPackSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer'
	],
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #tests }
PBMsgPackSerializerTest >> assertDeserialize: aString equals: anObject [
	self assert: (serializer deserialize: aString) equals: anObject
]

{ #category : #tests }
PBMsgPackSerializerTest >> assertSerialize: anObject equals: aString [
	self assert: (serializer serialize: anObject) equals: aString
]

{ #category : #tests }
PBMsgPackSerializerTest >> setUp [
	super setUp.
	serializer := PBMsgPackSerializer new
]

{ #category : #tests }
PBMsgPackSerializerTest >> testDeserializeArray [
	self assertDeserialize: #[146 33 163 102 111 111] equals: #(33 'foo')
]

{ #category : #tests }
PBMsgPackSerializerTest >> testDeserializeByteArray [
	self assertDeserialize: #[196 4 3 44 78 9] equals: #[3 44 78 9]
]

{ #category : #tests }
PBMsgPackSerializerTest >> testDeserializeNestedArray [
	self assertDeserialize: #[146 33 146 163 102 111 111 163 98 97 114] equals: #(33 #('foo' 'bar'))
]

{ #category : #tests }
PBMsgPackSerializerTest >> testDeserializeNil [
	self assertDeserialize: #[192] equals: nil
]

{ #category : #tests }
PBMsgPackSerializerTest >> testSerializeNestedArrays [
	self assertSerialize: #(33 #('foo' 'bar')) equals: #[146 33 146 163 102 111 111 163 98 97 114]
]
