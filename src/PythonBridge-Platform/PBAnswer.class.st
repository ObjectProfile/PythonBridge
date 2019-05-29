Class {
	#name : #PBAnswer,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBAnswer class >> decode: dict [
	| type ansCls |
	type := dict at: #type.
	ansCls := self withAllSubclasses detect: [ :cls | cls type = type ].
	^ ansCls fromDict: dict
]

{ #category : #accessing }
PBAnswer class >> fromDict: dict [
	self subclassResponsibility
]

{ #category : #accessing }
PBAnswer class >> messageClass [
	^ PBMessage
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
