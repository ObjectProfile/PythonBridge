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
PBDeserializer >> application [
	^ self executionHandler application
]

{ #category : #'private protocol' }
PBDeserializer >> buildProxyFor: rawObject [
	| proxy |
	proxy :=  PBProxyObject 
					pythonClass: (rawObject at: #__pyclass__)
					pythonVar: (rawObject at: #__pyid__) asP3GI
					application: self application.
	self executionHandler registerObject: proxy.
	^ proxy
]

{ #category : #'private protocol' }
PBDeserializer >> deserialize: str [
	| rawObj |
	rawObj := NeoJSONReader fromString: str.
	rawObj isDictionary ifFalse: [ ^ rawObj ].
	rawObj at: #__pyid__ ifAbsent: [ ^ rawObj ].
	^ self objectRegistry resolve: (rawObj at: #__pyid__) ifAbsent: [ self buildProxyFor: rawObj ]
]

{ #category : #'private protocol' }
PBDeserializer >> objectRegistry [
	^ self executionHandler objectRegistry
]
