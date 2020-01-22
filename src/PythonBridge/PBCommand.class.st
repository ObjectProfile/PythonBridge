Class {
	#name : #PBCommand,
	#superclass : #Object,
	#instVars : [
		'id',
		'instructions',
		'bindings',
		'observers',
		'promise',
		'transformBlock'
	],
	#category : #'PythonBridge-Execution'
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
PBCommand >> getObserver: observerId [
	^ observers detect: [ :obs | obs id = observerId ]
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
	id := PBPlatform current newRandomName.
	bindings := #().
	observers := #().
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
	^ [ self id isString and: [ 
			(self bindings allSatisfy: [ :assoc | assoc key isString ]) and: [ 
				self observers allSatisfy: [ :obs | obs callback isBlock ] ] ] ] on: Error do: [ false ]
]

{ #category : #accessing }
PBCommand >> observers [
	^ observers
]

{ #category : #accessing }
PBCommand >> observers: anObject [
	observers := anObject
]

{ #category : #accessing }
PBCommand >> promise [
	^ promise
]

{ #category : #accessing }
PBCommand >> promise: anObject [
	promise := anObject
]

{ #category : #'as yet unclassified' }
PBCommand >> pythonCode [
	| py3CodeStream |
	py3CodeStream := String new writeStream.
	self instructions do: [ :instr | 
			instr writePython3On: py3CodeStream.
			py3CodeStream << String lf ].
	^ py3CodeStream contents
]

{ #category : #accessing }
PBCommand >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
PBCommand >> transformBlock: anObject [
	transformBlock := anObject
]
