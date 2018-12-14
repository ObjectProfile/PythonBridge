Class {
	#name : #PBCommand,
	#superclass : #Object,
	#instVars : [
		'id',
		'instructions',
		'bindings',
		'transformBlock'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBCommand >> bindings [
	^ bindings
]

{ #category : #accessing }
PBCommand >> bindings: bindingCol [
	bindings := bindingCol
]

{ #category : #accessing }
PBCommand >> bindingsDictionary [
	^ self bindings asDictionary
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
	bindings := #().
	instructions := OrderedCollection new.
	transformBlock := #yourself
]

{ #category : #accessing }
PBCommand >> instructions [
	^ instructions
]

{ #category : #accessing }
PBCommand >> instructions: anObject [
	instructions := anObject
]

{ #category : #testing }
PBCommand >> isValid [
	^ [ self id isString and: [ self bindings allSatisfy: [ :assoc | assoc key isString ] ] ] on: Error do: [ false ]
]

{ #category : #'as yet unclassified' }
PBCommand >> pythonCode [
	| py3CodeStream |
	py3CodeStream := String new writeStream.
	(P3GInstructionsList new
		addAll: self instructions;
		yourself) writePython3On: py3CodeStream.
	^ py3CodeStream contents
]
