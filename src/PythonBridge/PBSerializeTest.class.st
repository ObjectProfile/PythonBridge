Class {
	#name : #PBSerializeTest,
	#superclass : #TestCase,
	#instVars : [
		'mapper'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSerializeTest >> serializer [
	^ mapper serializer
			serializerWrapper: PBPlatform current class httpMessageBrokerClass serializer;
			yourself
]

{ #category : #tests }
PBSerializeTest >> setUp [
	super setUp.
	mapper := PBMapperFactory forExecutionHandler: self
]

{ #category : #tests }
PBSerializeTest >> testSerializeArray [
	self assert: (self serializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]

{ #category : #tests }
PBSerializeTest >> testSerializeNil [
	self assert: (self serializer serialize: nil) equals: 'null'
]
