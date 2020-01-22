Class {
	#name : #PBAbstractWeakRegistry,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBAbstractWeakRegistry >> destroy [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PBAbstractWeakRegistry >> registerObject: anObject finalizer: finalizer [
	self subclassResponsibility
]
