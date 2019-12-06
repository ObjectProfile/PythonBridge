Class {
	#name : #PBMapperFactory,
	#superclass : #Object,
	#instVars : [
		'executionHandler',
		'serializationMappings',
		'deserializationMappings'
	],
	#category : #'PythonBridge-Serialization'
}

{ #category : #'as yet unclassified' }
PBMapperFactory class >> forExecutionHandler: handler [
	^ self new
		executionHandler: handler;
		yourself
]

{ #category : #initialization }
PBMapperFactory >> deserializer [
	^ self deserializerClass
				mappings: serializationMappings
				executionHandler: executionHandler
]

{ #category : #initialization }
PBMapperFactory >> deserializerClass [
	^ PBDeserializer
]

{ #category : #accessing }
PBMapperFactory >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
PBMapperFactory >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #initialization }
PBMapperFactory >> initialize [
	super initialize.
	serializationMappings := OrderedCollection new.
	deserializationMappings := OrderedCollection new 
]

{ #category : #initialization }
PBMapperFactory >> serializer [
	^ self serializerClass 
				mappings: serializationMappings
				executionHandler: executionHandler
]

{ #category : #initialization }
PBMapperFactory >> serializerClass [
	^ PBSerializer
]
