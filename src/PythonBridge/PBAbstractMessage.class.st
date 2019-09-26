Class {
	#name : #PBAbstractMessage,
	#superclass : #Object,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBAbstractMessage class >> type [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractMessage >> type [
	^ self class type
]
