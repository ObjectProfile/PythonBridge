Class {
	#name : #PBAnswer,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBAnswer class >> messageClass [
	self subclassResponsibility
]

{ #category : #accessing }
PBAnswer class >> type [
	^ self messageClass type
]

{ #category : #encoding }
PBAnswer >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type.
	self privateEncode: dict.
	^ NeoJSONWriter toString: dict
]

{ #category : #encoding }
PBAnswer >> privateEncode: dict [
	self subclassResponsibility
]

{ #category : #accessing }
PBAnswer >> type [
	^ self class type
]
