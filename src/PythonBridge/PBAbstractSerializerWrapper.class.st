Class {
	#name : #PBAbstractSerializerWrapper,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #private }
PBAbstractSerializerWrapper >> deserialize: aString [
	self subclassResponsibility
]

{ #category : #private }
PBAbstractSerializerWrapper >> serialize: anObject [
	self subclassResponsibility
]
