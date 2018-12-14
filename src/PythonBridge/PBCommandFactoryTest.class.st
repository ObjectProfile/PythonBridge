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
	self assert: command instructions isEmpty.
	self assert: command bindings isEmpty
]

{ #category : #tests }
PBCommandFactoryTest >> testBuildFullCommand [
	| command instructions |
	factory << (P3GString string: 'foo').
	factory bindingAt: #myVar put: 3.
	command := factory buildCommand.
	instructions := command instructions.
	self assert: instructions first class equals: P3GString.
	self assert: instructions first string equals: 'foo'.
	self assert: (command bindingsDictionary at: #myVar) equals: 3
]

{ #category : #tests }
PBCommandFactoryTest >> testBuildSimpleCommand [
	| command instructions |
	factory << (P3GString string: 'foo').
	command := factory buildCommand.
	instructions := command instructions.
	self assert: instructions first class equals: P3GString.
	self assert: instructions first string equals: 'foo' 
]
