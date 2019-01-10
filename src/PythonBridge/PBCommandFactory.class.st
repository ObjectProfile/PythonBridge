Class {
	#name : #PBCommandFactory,
	#superclass : #Object,
	#instVars : [
		'application',
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

{ #category : #accessing }
PBCommandFactory >> application [
	^ application
]

{ #category : #accessing }
PBCommandFactory >> application: anObject [
	application := anObject
]

{ #category : #streaming }
PBCommandFactory >> bindingAt: varName put: anObject [
	bindingsDictionary at: varName put: anObject
]

{ #category : #'as yet unclassified' }
PBCommandFactory >> buildCommand [
	| finishedCommand |
	finishedCommand := command
								instructions: self instructionsWithNotifyAtEnd;
								bindings: bindingsDictionary associations;
								yourself.
	self initialize.
	^ finishedCommand
]

{ #category : #initialization }
PBCommandFactory >> initialize [
	super initialize.
	self reset
]

{ #category : #'as yet unclassified' }
PBCommandFactory >> instructionsWithNotifyAtEnd [
	| instructions |
	instructions := instructionStream contents.
	instructions ifEmpty: [ instructions := OrderedCollection with: nil ].
	instructions last isPythonValue ifFalse: [ 
		instructions := instructions asOrderedCollection.
		instructions add: nil ].
	instructions 
		at: instructions size 
		put: (self setNotifyToInstruction: instructions last).
	^ instructions
]

{ #category : #initialization }
PBCommandFactory >> reset [
	instructionStream := OrderedCollection new writeStream.
	bindingsDictionary := Dictionary new.
	command := PBCommand new
]

{ #category : #'old api' }
PBCommandFactory >> send [
	^ self application send: self buildCommand
]

{ #category : #initialization }
PBCommandFactory >> setNotifyToInstruction: aP3gInstruction [
	^ 'notify' asP3GIdentifier 
			callWith: (Array with: aP3gInstruction with: command id)
]
