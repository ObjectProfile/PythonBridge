Class {
	#name : #PBRSyncMessage,
	#superclass : #PBRMessage,
	#instVars : [
		'syncId'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBRSyncMessage class >> answerClass [
	^ PBRAnswer
]

{ #category : #accessing }
PBRSyncMessage >> answerClass [
	^ self class answerClass
]

{ #category : #accessing }
PBRSyncMessage >> createAnswer [
	^ self answerClass answerFor: self
]

{ #category : #'as yet unclassified' }
PBRSyncMessage >> privateDecode: dict [
	super privateDecode: dict.
	syncId := dict at: #__sync
]

{ #category : #accessing }
PBRSyncMessage >> syncId [
	^ syncId
]
