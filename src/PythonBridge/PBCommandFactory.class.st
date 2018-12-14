Class {
	#name : #PBCommandFactory,
	#superclass : #Object,
	#instVars : [
		'bindingsDictionary',
		'instructionStream'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #streaming }
PBCommandFactory >> << aPythonStatement [
	instructionStream << aPythonStatement
]

{ #category : #streaming }
PBCommandFactory >> bindingAt: varName put: anObject [
	bindingsDictionary at: varName put: anObject
]

{ #category : #initialization }
PBCommandFactory >> buildCommand [
	^ PBCommand new
		instructions: instructionStream contents;
		bindings: bindingsDictionary associations;
		yourself
]

{ #category : #initialization }
PBCommandFactory >> initialize [
	instructionStream := OrderedCollection new writeStream.
	bindingsDictionary := Dictionary new
]
