Class {
	#name : #PBCommandFactory,
	#superclass : #Object,
	#instVars : [
		'application',
		'bindingsDictionary',
		'observers',
		'transformBlock',
		'command',
		'instructions'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #streaming }
PBCommandFactory >> << aPythonStatement [
	instructions add: aPythonStatement
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

{ #category : #streaming }
PBCommandFactory >> append: aPythonStatement [
	instructions add: aPythonStatement
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
	| instructionsCopy |
	instructionsCopy := instructions copy.
	instructionsCopy ifEmpty: [ instructionsCopy := OrderedCollection with: nil ].
	instructionsCopy last isPythonValue ifFalse: [ 
		instructionsCopy := instructionsCopy asOrderedCollection.
		instructionsCopy add: nil ].
	instructionsCopy 
		at: instructionsCopy size 
		put: (self setNotifyToInstruction: instructionsCopy last).
	^ instructionsCopy
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
	instructions := OrderedCollection new.
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
PBCommandFactory >> sendAndWait [
	^ self sendCommand waitForValue
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
