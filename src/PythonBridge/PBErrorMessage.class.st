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
PBErrorMessage class >> type [
	^ #ERR
]

{ #category : #'as yet unclassified' }
PBErrorMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	errorMessage := dict at: #errMsg.
	trace := dict at: #value
]
