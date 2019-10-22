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
PBMsgPackSerializerTest >> testDeserializeLargeString [
	self assertDeserialize: #[187 112 98 54 102 54 108 55 97 113 104 122 56 48 107 115 105 56 105 57 48 101 53 105 101 120 101 114] equals: 'pb6f6l7aqhz80ksi8i90e5iexer'
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
PBMsgPackSerializerTest >> testSerializeLargeString [
	self assertSerialize: 'pb6f6l7aqhz80ksi8i90e5iexer' equals: #[218 0 27 112 98 54 102 54 108 55 97 113 104 122 56 48 107 115 105 56 105 57 48 101 53 105 101 120 101 114]
]

{ #category : #tests }
PBMsgPackSerializerTest >> testSerializeNestedArrays [
	self assertSerialize: #(33 #('foo' 'bar')) equals: #[146 33 146 163 102 111 111 163 98 97 114]
]

{ #category : #tests }
PBMsgPackSerializerTest >> testSmallInt [
	self assertSerialize: 33 equals: #[ 33 ]
]
