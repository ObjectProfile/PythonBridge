Class {
	#name : #PBOldStubMessage,
	#superclass : #PBOldMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'PythonBridge-Platform-Messages-Old'
}

{ #category : #'as yet unclassified' }
PBOldStubMessage class >> ivar1: ivar1 ivar2: ivar2 [
	^ self new
		ivar1: ivar1;
		ivar2: ivar2;
		yourself
]

{ #category : #accessing }
PBOldStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
PBOldStubMessage >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
PBOldStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #accessing }
PBOldStubMessage >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encoding }
PBOldStubMessage >> privateEncode: dict [
	dict at: #ivar1 put: ivar1.
	dict at: #ivar2 put: ivar2
]
