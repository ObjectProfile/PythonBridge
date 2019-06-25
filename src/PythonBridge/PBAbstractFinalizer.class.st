Class {
	#name : #PBAbstractFinalizer,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #finalization }
PBAbstractFinalizer >> finalize [
	self subclassResponsibility
]
