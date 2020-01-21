Class {
	#name : #PBObjectFinalizer,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #finalization }
PBObjectFinalizer >> finalize [
	self subclassResponsibility
]
