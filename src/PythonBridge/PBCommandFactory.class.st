Class {
	#name : #PBCommandFactory,
	#superclass : #Object,
	#instVars : [
		'application',
		'bindingsDictionary',
		'observers',
		'instructionStream',
		'transformBlock',
		'command'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #streaming }
PBCommandFactory >> << aPythonStatement [
	instructionStream << aPythonStatement
]

{ #category : #bindings }
PBCommandFactory >> addBinding: aBinding [
	bindingsDictionary at: aBinding pythonVariable name put: aBinding object.
	^ aBinding
]

{ #category : #observers }
PBCommandFactory >> addObserver: anObserver [
	observers add: anObserver.
	^ anObserver
]

{ #category : #accessing }
PBCommandFactory >> application [
	^ application
]

{ #category : #accessing }
PBCommandFactory >> application: anObject [
	application := anObject
]

{ #category : #bindings }
PBCommandFactory >> bindingAt: varName put: anObject [
	bindingsDictionary at: varName put: anObject.
	^ PBBinding key: varName wrap: anObject
]

{ #category : #bindings }
PBCommandFactory >> bindingWrap: anObject [
	^ self addBinding: (PBBinding wrap: anObject)
]

{ #category : #send }
PBCommandFactory >> buildCommand [
	| finishedCommand |
	finishedCommand := command
								instructions: self instructionsWithNotifyAtEnd;
								bindings: bindingsDictionary associations;
								observers: observers;
								transformBlock: transformBlock;
								yourself.
	self initialize.
	^ finishedCommand
]

{ #category : #accessing }
PBCommandFactory >> decorateTransform: aBlock [
	| previousBlock |
	previousBlock := transformBlock.
	^ transformBlock := [ :obj | aBlock value: (previousBlock value: obj) ]
]

{ #category : #initialization }
PBCommandFactory >> initialize [
	super initialize.
	self reset
]

{ #category : #accessing }
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

{ #category : #observers }
PBCommandFactory >> observerFromCallback: aBlock [
	| observer |
	observer := (PBObserver callback: aBlock)
						command: command;
						yourself.
	^ self addObserver: observer
]

{ #category : #initialization }
PBCommandFactory >> reset [
	instructionStream := OrderedCollection new writeStream.
	bindingsDictionary := Dictionary new.
	observers := OrderedCollection new.
	command := PBCommand new.
	transformBlock := #yourself
]

{ #category : #send }
PBCommandFactory >> send [
	^ self sendCommand
]

{ #category : #send }
PBCommandFactory >> sendCommand [
	^ self application send: self buildCommand
]

{ #category : #initialization }
PBCommandFactory >> setNotifyToInstruction: aP3gInstruction [
	^ 'notify' asP3GIdentifier 
			callWith: (Array with: aP3gInstruction with: command id)
]

{ #category : #accessing }
PBCommandFactory >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
PBCommandFactory >> transformBlock: anObject [
	transformBlock := anObject
]
