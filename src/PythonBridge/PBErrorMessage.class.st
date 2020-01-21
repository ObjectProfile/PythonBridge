Class {
	#name : #PBErrorMessage,
	#superclass : #PBRSyncMessage,
	#instVars : [
		'commandId',
		'errorMessage',
		'trace'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBErrorMessage class >> answerClass [
	^ PBErrorAnswer
]

{ #category : #accessing }
PBErrorMessage class >> type [
	^ #ERR
]

{ #category : #accessing }
PBErrorMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
PBErrorMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #accessing }
PBErrorMessage >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
PBErrorMessage >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #'as yet unclassified' }
PBErrorMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	errorMessage := dict at: #errMsg.
	trace := dict at: #trace
]

{ #category : #accessing }
PBErrorMessage >> trace [
	^ trace
]

{ #category : #accessing }
PBErrorMessage >> trace: anObject [
	trace := anObject
]
