Class {
	#name : #PBMapper,
	#superclass : #Object,
	#instVars : [
		'mappings',
		'executionHandler',
		'application'
	],
	#category : #'PythonBridge-Serialization'
}

{ #category : #'as yet unclassified' }
PBMapper class >> mappings: mappings executionHandler: handler [
	^ self new
			mappings: mappings;
			executionHandler: handler;
			yourself
]

{ #category : #accessing }
PBMapper >> application [
	^ executionHandler application
]

{ #category : #accessing }
PBMapper >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PBMapper >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
PBMapper >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #accessing }
PBMapper >> mappings [
	^ mappings
]

{ #category : #accessing }
PBMapper >> mappings: anObject [
	mappings := anObject
]