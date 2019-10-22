Class {
	#name : #PBRStubAnswer,
	#superclass : #PBRAnswer,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBRStubAnswer >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
PBRStubAnswer >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encoding }
PBRStubAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #ivar1 put: ivar1.
	dict at: #ivar2f put: ivar2 first.
	dict at: #ivar2r put: ivar2 allButFirst.
]
