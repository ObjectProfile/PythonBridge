Class {
	#name : #PBDeserializer,
	#superclass : #Object,
	#category : #'PythonBridge-Core'
}

{ #category : #'private protocol' }
PBDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
PBDeserializer >> deserialize: anObject [
	^ NeoJSONReader fromString: anObject
]
