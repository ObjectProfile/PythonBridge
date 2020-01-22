Class {
	#name : #PBAbstractMessage,
	#superclass : #Object,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #testing }
PBAbstractMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractMessage class >> type [
	self subclassResponsibility
]

{ #category : #testing }
PBAbstractMessage >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ self class isReverseMessage
]

{ #category : #accessing }
PBAbstractMessage >> type [
	^ self class type
]
