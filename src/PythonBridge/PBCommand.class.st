Class {
	#name : #PBCommand,
	#superclass : #Object,
	#instVars : [
		'id',
		'pythonGenerable',
		'bindings'
	],
	#category : #PythonBridge
}

{ #category : #accessing }
PBCommand >> bindings [
	^ bindings
]

{ #category : #accessing }
PBCommand >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
PBCommand >> id [
	^ id
]

{ #category : #accessing }
PBCommand >> id: anObject [
	id := anObject
]

{ #category : #initialization }
PBCommand >> initialize [
	super initialize.
	id := UUID new asString36.
	bindings := #()
]

{ #category : #testing }
PBCommand >> isValid [
	^ [ self id isString and: [ self bindings allSatisfy: [ :assoc | assoc key isString ] ] ] on: Error do: [ false ]
]

{ #category : #accessing }
PBCommand >> pythonGenerable [
	^ pythonGenerable
]

{ #category : #accessing }
PBCommand >> pythonGenerable: anObject [
	pythonGenerable := anObject
]
