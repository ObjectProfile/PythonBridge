Class {
	#name : #PBNeoJsonSerializer,
	#superclass : #PBAbstractSerializerWrapper,
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #private }
PBNeoJsonSerializer >> deserialize: aString [
	^ NeoJSONReader fromString: aString
]

{ #category : #private }
PBNeoJsonSerializer >> serialize: anObject [
	^ NeoJSONWriter toString: anObject
]
