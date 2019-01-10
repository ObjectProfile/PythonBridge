Class {
	#name : #PBSendCommandTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSendCommandTest >> testSendAssignAsLastMessage [
	self cf << (#foo asP3GI <- 33).
	self cfSend.
	self assert: promise waitForValue equals: nil
]

{ #category : #tests }
PBSendCommandTest >> testSendImportAsLastMessage [
	self cf << #sys asP3GI import.
	self cfSend.
	self assert: promise waitForValue equals: nil
]
