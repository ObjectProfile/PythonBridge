Class {
	#name : #PBCommandFactoryTest,
	#superclass : #TestCase,
	#instVars : [
		'factory'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBCommandFactoryTest >> setUp [
	factory := PBCommandFactory new
]

{ #category : #tests }
PBCommandFactoryTest >> testBuildEmptyCommand [
	| command |
	command := factory buildCommand.
	self assert: command instructions size equals: 1.
	self assert: command instructions first class equals: P3GCall.
	self assert: command instructions first target name equals: 'notify'.
	self assert: command instructions first positionalArguments first equals: nil.
	self assert: command bindings isEmpty
]

{ #category : #tests }
PBCommandFactoryTest >> testBuildFullCommand [
	| command instructions |
	factory << (P3GString string: 'foo').
	factory bindingAt: #myVar put: 3.
	command := factory buildCommand.
	instructions := command instructions.
	self assert: command instructions first positionalArguments first string equals: 'foo'.
	self assert: (command bindingsDictionary at: #myVar) equals: 3
]

{ #category : #tests }
PBCommandFactoryTest >> testBuildSimpleCommand [
	| command instructions |
	factory << (P3GString string: 'foo').
	command := factory buildCommand.
	instructions := command instructions.
	self assert: command instructions first positionalArguments first string equals: 'foo'.
]

{ #category : #tests }
PBCommandFactoryTest >> testBuildWithObservers [
	| command |
	factory observerFromCallback: [ 32 ].
	command := factory buildCommand.
	self assert: command observers first callback value equals: 32.
]
