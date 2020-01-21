Class {
	#name : #PBMessage,
	#superclass : #PBAbstractMessage,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #testing }
PBMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ false
]

{ #category : #accessing }
PBMessage class >> type [
	^ #MSG
]

{ #category : #encoding }
PBMessage >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type. 
	self privateEncode: dict.
	^ dict
]

{ #category : #testing }
PBMessage >> isSync [
	self subclassResponsibility
]

{ #category : #encoding }
PBMessage >> privateEncode: dict [
]
