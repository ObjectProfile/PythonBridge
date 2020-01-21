Class {
	#name : #PBReplaceCommand,
	#superclass : #PBErrorHandlingAction,
	#instVars : [
		'newCommand'
	],
	#category : #'PythonBridge-ErrorHandling'
}

{ #category : #'as yet unclassified' }
PBReplaceCommand >> actionSymbol [
	^ #'REPLACE_COMMAND'
]

{ #category : #'as yet unclassified' }
PBReplaceCommand >> encodeAsDictionary [
	| response |
	response := super encodeAsDictionary.
	response at: #command put: newCommand encodeAsDictionary.
	^ response
]

{ #category : #accessing }
PBReplaceCommand >> newCommand [
	^ newCommand
]

{ #category : #accessing }
PBReplaceCommand >> newCommand: anObject [
	newCommand := anObject
]
