Class {
	#name : #PBSerializer,
	#superclass : #Object,
	#category : #'PythonBridge-Core'
}

{ #category : #private }
PBSerializer class >> deserialize: anObject [
	^ PBDeserializer deserialize: anObject
]

{ #category : #private }
PBSerializer class >> serialize: anObject [
	^ self new
		serialize: anObject
]

{ #category : #api }
PBSerializer >> serialize: anObject [
	^ NeoJSONWriter toString: anObject
]
