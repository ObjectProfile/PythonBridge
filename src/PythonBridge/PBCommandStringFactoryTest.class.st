Class {
	#name : #PBCommandStringFactoryTest,
	#superclass : #TestCase,
	#instVars : [
		'factory'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBCommandStringFactoryTest >> setUp [
	factory := PBCommandStringFactory new
]

{ #category : #tests }
PBCommandStringFactoryTest >> testBuildEmptyCommand [
	| command |
	command := factory buildCommand.
	self assert: command class equals: PBCommandString.
	self assert: (command pythonCode trimLeft beginsWith: 'notify(None,').
	self assert: command bindings isEmpty
]

{ #category : #tests }
PBCommandStringFactoryTest >> testBuildFullCommand [
	| command |

	factory script: 'foo'.
	factory bindingAt: #myVar put: 3.
	command := factory buildCommand.
	self assert: command pythonCode lines first equals: 'foo'.
	self assert: (command bindingsDictionary at: #myVar) equals: 3
]

{ #category : #tests }
PBCommandStringFactoryTest >> testBuildWithObservers [
	| command |
	factory observerFromCallback: [ 32 ].
	command := factory buildCommand.
	self assert: command observers first callback value equals: 32.
]
