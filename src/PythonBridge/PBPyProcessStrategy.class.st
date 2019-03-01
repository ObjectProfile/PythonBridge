Class {
	#name : #PBPyProcessStrategy,
	#superclass : #Object,
	#instVars : [
		'process',
		'workingDirectory',
		'pharoPort',
		'pythonPort'
	],
	#classVars : [
		'Default'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBPyProcessStrategy class >> default [
	^ Default ifNil: [ self default: PBPipenvPyStrategy  ]
]

{ #category : #accessing }
PBPyProcessStrategy class >> default: aProcessStrategyClass [
	Default := aProcessStrategyClass.
	Default prepare.
	^ Default
]

{ #category : #'class initialization' }
PBPyProcessStrategy class >> initialize [
	self default
]

{ #category : #'as yet unclassified' }
PBPyProcessStrategy class >> prepare [
]

{ #category : #accessing }
PBPyProcessStrategy class >> setAsDefault [
	self == PBPyProcessStrategy ifTrue: [ Error signal: 'To be called by subclasses' ].
	self default: self
]

{ #category : #accessing }
PBPyProcessStrategy class >> workingDirectory: wd pharoPort: pharoPort pythonPort: pyPort [
	^ self new
		workingDirectory: wd;
		pharoPort: pharoPort;
		pythonPort: pyPort;
		yourself
]

{ #category : #testing }
PBPyProcessStrategy >> isRunning [
	process ifNil: [ ^ false ].
	^ process isRunning
]

{ #category : #accessing }
PBPyProcessStrategy >> pharoPort [
	^ pharoPort
]

{ #category : #accessing }
PBPyProcessStrategy >> pharoPort: anObject [
	pharoPort := anObject
]

{ #category : #accessing }
PBPyProcessStrategy >> process [
	^ process
]

{ #category : #accessing }
PBPyProcessStrategy >> pythonPort [
	^ pythonPort
]

{ #category : #accessing }
PBPyProcessStrategy >> pythonPort: anObject [
	pythonPort := anObject
]

{ #category : #accessing }
PBPyProcessStrategy >> start [
	self subclassResponsibility
]

{ #category : #accessing }
PBPyProcessStrategy >> stop [
	self subclassResponsibility
]

{ #category : #accessing }
PBPyProcessStrategy >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PBPyProcessStrategy >> workingDirectory: anObject [
	workingDirectory := anObject
]
