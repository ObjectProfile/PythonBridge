Class {
	#name : #PBMapper,
	#superclass : #Object,
	#instVars : [
		'mappings',
		'application'
	],
	#category : #'PythonBridge-Serialization'
}

{ #category : #'as yet unclassified' }
PBMapper class >> mappings: mappings application: application [
	^ self new
			mappings: mappings;
			application: application;
			yourself
]

{ #category : #accessing }
PBMapper >> application [
	^ application
]

{ #category : #accessing }
PBMapper >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PBMapper >> mappings [
	^ mappings
]

{ #category : #accessing }
PBMapper >> mappings: anObject [
	mappings := anObject
]
