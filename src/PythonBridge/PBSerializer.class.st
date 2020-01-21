Class {
	#name : #PBSerializer,
	#superclass : #PBMapper,
	#category : #'PythonBridge-Serialization'
}

{ #category : #private }
PBSerializer class >> deserialize: anObject [
	^ PBDeserializer deserialize: anObject
]

{ #category : #private }
PBSerializer class >> deserialize: anObject forApplication: application [
	^ PBDeserializer deserialize: anObject forApplication: application
]

{ #category : #private }
PBSerializer class >> serialize: anObject [
	^ self new
		serialize: anObject
]

{ #category : #api }
PBSerializer >> serialize: anObject [
	^ serializerWrapper serialize: anObject
]
