Class {
	#name : #PBObserver,
	#superclass : #Object,
	#traits : 'P3GCallable',
	#classTraits : 'P3GCallable classTrait',
	#instVars : [
		'id',
		'callback',
		'command'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #accessing }
PBObserver class >> callback: aBlock [
	^ self new
		callback: aBlock;
		yourself
]

{ #category : #accessing }
PBObserver >> callback [
	^ callback
]

{ #category : #accessing }
PBObserver >> callback: anObject [
	callback := anObject
]

{ #category : #accessing }
PBObserver >> command [
	^ command
]

{ #category : #accessing }
PBObserver >> command: anObject [
	command := anObject
]

{ #category : #accessing }
PBObserver >> id [
	^ id
]

{ #category : #initialization }
PBObserver >> initialize [
	super initialize.
	id := PBUtils newP3VariableName
]

{ #category : #testing }
PBObserver >> isPythonGenerable [
	^ true
]

{ #category : #testing }
PBObserver >> isPythonValue [
	^ true
]

{ #category : #'error handling' }
PBObserver >> pharoNotify: anObject [
	^ callback cull: anObject
]

{ #category : #'error handling' }
PBObserver >> pythonNotify [
	^ self pythonNotify: nil
]

{ #category : #'error handling' }
PBObserver >> pythonNotify: anObject [
	^ self callWith: (Array with: anObject)
]

{ #category : #testing }
PBObserver >> writePython3On: aStream [
	(#observer asP3GI callWith: (Array 
											with: self command id
											with: self id)) writePython3On: aStream
]
