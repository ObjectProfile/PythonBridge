Class {
	#name : #PBNeoJsonSerializer,
	#superclass : #PBAbstractSerializerWrapper,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #private }
PBNeoJsonSerializer >> deserialize: aString [
	^ NeoJSONReader fromString: aString
]

{ #category : #private }
PBNeoJsonSerializer >> serialize: anObject [
	^ NeoJSONWriter toString: anObject
]
