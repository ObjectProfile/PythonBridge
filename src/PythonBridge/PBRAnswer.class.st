Class {
	#name : #PBRAnswer,
	#superclass : #PBAbstractAnswer,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #encoding }
PBRAnswer >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type. 
	self privateEncode: dict.
	^ dict
]

{ #category : #encoding }
PBRAnswer >> privateEncode: dict [
	dict at: #__sync put: self syncId
]

{ #category : #writing }
PBRAnswer >> syncId [
	^ message syncId
]
