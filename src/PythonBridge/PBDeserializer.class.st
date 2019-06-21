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
	^ self privateDeserialize: (serializerWrapper deserialize: str).
]

{ #category : #'private protocol' }
PBDeserializer >> objectRegistry [
	^ self executionHandler objectRegistry
]

{ #category : #'private protocol' }
PBDeserializer >> privateDeserialize: rawObj [
	rawObj isCollection ifFalse: [ ^ rawObj ].
	rawObj isDictionary and: [ (rawObj includesKey: #__pyid__) 
		ifTrue: [ ^ self reifyProxyFor: rawObj ] ].
	^ rawObj collect: [ :elem | self privateDeserialize: elem ]
]

{ #category : #'private protocol' }
PBDeserializer >> reifyProxyFor: rawObj [
	^ self objectRegistry resolve: (rawObj at: #__pyid__) ifAbsent: [ self buildProxyFor: rawObj ]
]
