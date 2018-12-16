Class {
	#name : #PBCommandFactory,
	#superclass : #Object,
	#instVars : [
		'bindingsDictionary',
		'instructionStream',
		'command'
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

{ #category : #'as yet unclassified' }
PBCommandFactory >> buildCommand [
	^ command
		instructions: self instructionsWithNotifyAtEnd;
		bindings: bindingsDictionary associations;
		yourself
]

{ #category : #initialization }
PBCommandFactory >> initialize [
	instructionStream := OrderedCollection new writeStream.
	bindingsDictionary := Dictionary new.
	command := PBCommand new
]

{ #category : #'as yet unclassified' }
PBCommandFactory >> instructionsWithNotifyAtEnd [
	| instructions |
	instructions := instructionStream contents.
	instructions ifEmpty: [ instructions := OrderedCollection with: nil ].
	instructions 
		at: instructions size 
		put: (self setNotifyToInstruction: instructions last).
	^ instructions
]

{ #category : #initialization }
PBCommandFactory >> setNotifyToInstruction: aP3gInstruction [
	^ 'notify' asP3GIdentifier 
			callWith: (Array with: aP3gInstruction with: command id)
]
