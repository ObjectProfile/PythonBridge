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
	current := nil.
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
