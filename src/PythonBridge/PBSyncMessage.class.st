Class {
	#name : #PBSyncMessage,
	#superclass : #PBMessage,
	#instVars : [
		'syncId'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBSyncMessage class >> answerClass [
	^ PBAnswer
]

{ #category : #accessing }
PBSyncMessage class >> type [
	^ #SYNC
]

{ #category : #accessing }
PBSyncMessage >> answerClass [
	^ self class answerClass
]

{ #category : #accessing }
PBSyncMessage >> createAnswer [
	^ self answerClass answerFor: self
]

{ #category : #initialization }
PBSyncMessage >> initialize [
	super initialize.
	syncId := PBPlatform current newRandomName
]

{ #category : #testing }
PBSyncMessage >> isSync [
	^ true
]

{ #category : #writing }
PBSyncMessage >> privateEncode: aDict [
	super privateEncode: aDict.
	aDict at: #__sync put: self syncId
]

{ #category : #writing }
PBSyncMessage >> syncId [
	^ syncId
]
