Class {
	#name : #PBDeserializer,
	#superclass : #PBMapper,
	#category : #'PythonBridge-Serialization'
}

{ #category : #'private protocol' }
PBDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
PBDeserializer >> buildProxyFor: rawObject [
	^ PBProxyObject 
			pythonClass: (rawObject at: #__pyclass__)
			application: self application
]

{ #category : #'private protocol' }
PBDeserializer >> deserialize: str [
	| rawObj clsName |
	rawObj := NeoJSONReader fromString: str.
	rawObj isDictionary ifFalse: [ ^ rawObj ].
	clsName := rawObj at: #__pyclass__ ifAbsent: [ ^ rawObj ].
	^ self buildProxyFor: rawObj
]
