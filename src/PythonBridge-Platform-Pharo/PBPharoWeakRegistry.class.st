Class {
	#name : #PBPharoWeakRegistry,
	#superclass : #PBAbstractWeakRegistry,
	#instVars : [
		'weakRegistry'
	],
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #'as yet unclassified' }
PBPharoWeakRegistry >> destroy [
	weakRegistry removeAll
]

{ #category : #initialization }
PBPharoWeakRegistry >> initialize [
	super initialize.
	weakRegistry := WeakRegistry new.
]

{ #category : #'as yet unclassified' }
PBPharoWeakRegistry >> registerObject: anObject finalizer: finalizer [
	weakRegistry 
		add: anObject
		executor: finalizer
]
