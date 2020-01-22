Class {
	#name : #PBErrorHandlingAction,
	#superclass : #Object,
	#category : #'PythonBridge-ErrorHandling'
}

{ #category : #'as yet unclassified' }
PBErrorHandlingAction >> actionSymbol [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PBErrorHandlingAction >> encodeAsDictionary [
	^ { #action -> self actionSymbol } asDictionary
]
