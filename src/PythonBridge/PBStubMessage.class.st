Class {
	#name : #PBStubMessage,
	#superclass : #PBSyncMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBStubMessage class >> answerClass [
	^ PBStubAnswer
]

{ #category : #accessing }
PBStubMessage class >> type [
	^ #STUB
]

{ #category : #accessing }
PBStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
PBStubMessage >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
PBStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #accessing }
PBStubMessage >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encode }
PBStubMessage >> privateEncode: aDict [
	super privateEncode: aDict.
	aDict at: #ivar1 put: ivar1.
	aDict at: #ivar2f put: ivar2 first.
	aDict at: #ivar2r put: ivar2 allButFirst.
]
