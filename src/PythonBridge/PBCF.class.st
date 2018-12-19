Class {
	#name : #PBCF,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBCF class >> buildCommand [
	| command |
	command := self current buildCommand.
	self reset.
	^ command
]

{ #category : #accessing }
PBCF class >> current [
	^ current ifNil: [ current := self newCommandFactory ]
]

{ #category : #'reflective operations' }
PBCF class >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: self current
]

{ #category : #'instance creation' }
PBCF class >> newCommandFactory [
	^ PBCommandFactory new
]

{ #category : #accessing }
PBCF class >> reset [
	current := nil
]
