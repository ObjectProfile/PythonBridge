Class {
	#name : #PBOldMessage,
	#superclass : #Object,
	#category : #'PythonBridge-Platform-Messages-Old'
}

{ #category : #accessing }
PBOldMessage class >> type [
	^ 'MSG'
]

{ #category : #encoding }
PBOldMessage >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type.
	self privateEncode: dict.
	^ dict
]

{ #category : #encoding }
PBOldMessage >> privateEncode: dict [
	self subclassResponsibility
]

{ #category : #acccessing }
PBOldMessage >> type [
	^ self class type
]
