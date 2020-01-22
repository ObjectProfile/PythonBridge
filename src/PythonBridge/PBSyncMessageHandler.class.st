Class {
	#name : #PBSyncMessageHandler,
	#superclass : #PBMessageHandler,
	#instVars : [
		'answer'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBSyncMessageHandler >> answer [
	^ answer
]

{ #category : #accessing }
PBSyncMessageHandler >> handleMessage [
	answer := callback value: message.
	self assert: answer class = message answerClass.
]

{ #category : #asserting }
PBSyncMessageHandler >> shouldAnswer [
	^ true
]
