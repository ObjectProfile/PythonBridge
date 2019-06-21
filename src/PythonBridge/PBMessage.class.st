Class {
	#name : #PBMessage,
	#superclass : #Object,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBMessage class >> type [
	^ 'MSG'
]

{ #category : #encoding }
PBMessage >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type.
	self privateEncode: dict.
	^ dict
]

{ #category : #encoding }
PBMessage >> privateEncode: dict [
	self subclassResponsibility
]

{ #category : #acccessing }
PBMessage >> type [
	^ self class type
]
