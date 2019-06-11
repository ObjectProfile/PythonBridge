Class {
	#name : #PBStubMessage,
	#superclass : #PBMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBStubMessage class >> ivar1: ivar1 ivar2: ivar2 [
	^ self new
		ivar1: ivar1;
		ivar2: ivar2;
		yourself
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

{ #category : #encoding }
PBStubMessage >> privateEncode: dict [
	dict at: #ivar1 put: ivar1.
	dict at: #ivar2 put: ivar2
]
