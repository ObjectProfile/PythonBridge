Class {
	#name : #PBMessage,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBMessage class >> type [
	self subclassResponsibility
]

{ #category : #encoding }
PBMessage >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type.
	self privateEncode: dict.
	^ NeoJSONWriter toString: dict
]

{ #category : #encoding }
PBMessage >> privateEncode: dict [
	self subclassResponsibility
]

{ #category : #acccessing }
PBMessage >> type [
	^ self class type
]
