Class {
	#name : #PBBinding,
	#superclass : #Object,
	#instVars : [
		'object',
		'key'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #'instance creation' }
PBBinding class >> key: aKey wrap: anObject [
	^ self new
		key: aKey;
		object: anObject;
		yourself
]

{ #category : #'instance creation' }
PBBinding class >> wrap: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #initialization }
PBBinding >> initialize [
	super initialize.
	key := PBUtils newP3VariableName
]

{ #category : #testing }
PBBinding >> isPythonGenerable [
	^ true
]

{ #category : #testing }
PBBinding >> isPythonValue [
	^ true
]

{ #category : #accessing }
PBBinding >> key [
	^ key
]

{ #category : #accessing }
PBBinding >> key: anObject [
	key := anObject
]

{ #category : #accessing }
PBBinding >> object [
	^ object
]

{ #category : #accessing }
PBBinding >> object: anObject [
	object := anObject
]

{ #category : #'instance creation' }
PBBinding >> pythonVariable [
	^ key asP3GI
]

{ #category : #testing }
PBBinding >> writePython3On: aStream [
	self pythonVariable writePython3On: aStream
]
