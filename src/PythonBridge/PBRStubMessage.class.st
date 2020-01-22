Class {
	#name : #PBRStubMessage,
	#superclass : #PBRSyncMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBRStubMessage class >> answerClass [
	^ PBRStubAnswer
]

{ #category : #accessing }
PBRStubMessage class >> type [
	^ #RSTUB
]

{ #category : #accessing }
PBRStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
PBRStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #'as yet unclassified' }
PBRStubMessage >> privateDecode: dict [
	super privateDecode: dict.
	ivar1 := dict at: #ivar1.
	ivar2 := {dict at: #ivar2f} , (dict at: #ivar2r)
]
