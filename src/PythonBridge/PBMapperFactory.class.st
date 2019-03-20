Class {
	#name : #PBMapperFactory,
	#superclass : #Object,
	#instVars : [
		'application',
		'serializationMappings',
		'deserializationMappings'
	],
	#category : #'PythonBridge-Serialization'
}

{ #category : #'as yet unclassified' }
PBMapperFactory class >> forApplication: application [
	^ self new
		application: application;
		yourself
]

{ #category : #accessing }
PBMapperFactory >> application [
	^ application
]

{ #category : #accessing }
PBMapperFactory >> application: anObject [
	application := anObject
]

{ #category : #initialization }
PBMapperFactory >> deserializer [
	^ self deserializerClass
				mappings: serializationMappings
				application: application
]

{ #category : #initialization }
PBMapperFactory >> deserializerClass [
	^ PBDeserializer
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
				application: application
]

{ #category : #initialization }
PBMapperFactory >> serializerClass [
	^ PBSerializer
]
