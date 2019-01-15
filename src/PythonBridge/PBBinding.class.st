Class {
	#name : #PBBinding,
	#superclass : #Object,
	#instVars : [
		'object',
		'key'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'instance creation' }
PBBinding class >> wrap: anObject [
	^ self new
		wrap: anObject;
		yourself
]

{ #category : #initialization }
PBBinding >> initialize [
	super initialize.
	key := self newPythonVar
]

{ #category : #testing }
PBBinding >> isPythonGenerable [
	^ true
]

{ #category : #testing }
PBBinding >> isPythonValue [
	^ true
]

{ #category : #'instance creation' }
PBBinding >> newPythonVar [
	^ ('pb' , UUID new asString36) asP3GIdentifier
]

{ #category : #accessing }
PBBinding >> object [
	^ object
]

{ #category : #accessing }
PBBinding >> object: anObject [
	object := anObject
]

{ #category : #testing }
PBBinding >> writePython3On: aStream [
	key writePython3On: aStream
]
