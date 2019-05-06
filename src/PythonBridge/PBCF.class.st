Class {
	#name : #PBCF,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #'PythonBridge-Global'
}

{ #category : #'as yet unclassified' }
PBCF class >> << aPythonStatement [
	^ self current << aPythonStatement
]

{ #category : #'as yet unclassified' }
PBCF class >> addBinding: aBinding [
	^ self current addBinding: aBinding
]

{ #category : #'as yet unclassified' }
PBCF class >> addObserver: anObserver [
	^ self current addObserver: anObserver
]

{ #category : #'as yet unclassified' }
PBCF class >> append: aPythonStatement [
	^ self current append: aPythonStatement
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
PBCF class >> bindingWrap: anObject [
	^ self current bindingWrap: anObject
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
	^ current
]

{ #category : #accessing }
PBCF class >> current: cf [
	current := cf
]

{ #category : #'reflective operations' }
PBCF class >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: self current
]

{ #category : #'instance creation' }
PBCF class >> newCommandFactory [
	^ self application newCommandFactory
]

{ #category : #'as yet unclassified' }
PBCF class >> observerFromCallback: aBlock [
	^ self current observerFromCallback: aBlock
]

{ #category : #accessing }
PBCF class >> reset [
	current := self newCommandFactory
]

{ #category : #'old api' }
PBCF class >> send [
	^ self application send: self buildCommand
]

{ #category : #'old api' }
PBCF class >> sendAndWait [
	^ self send waitForValue
]

{ #category : #'as yet unclassified' }
PBCF class >> transformBlock: aBlock [
	^ self current transformBlock: aBlock
]
