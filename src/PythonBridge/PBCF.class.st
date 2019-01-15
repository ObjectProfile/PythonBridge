Class {
	#name : #PBCF,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBCF class >> << aPythonStatement [
	^ self current << aPythonStatement
]

{ #category : #'as yet unclassified' }
PBCF class >> addBinding: aBinding [
	^ self current addBinding: aBinding
]

{ #category : #initialization }
PBCF class >> application [
	^ self applicationClass uniqueInstance
]

{ #category : #initialization }
PBCF class >> applicationClass [
	^ PBApplication
]

{ #category : #'as yet unclassified' }
PBCF class >> bindingAt: varName put: anObject [
	^ self current bindingAt: varName put: anObject
]

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
	^ self application newCommandFactory
]

{ #category : #accessing }
PBCF class >> reset [
	current := nil
]

{ #category : #'old api' }
PBCF class >> send [
	^ self application send: self buildCommand
]
