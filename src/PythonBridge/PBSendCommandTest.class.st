Class {
	#name : #PBSendCommandTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSendCommandTest >> testSendImportAsLastMessage [
	self cf << nil.
	self cfSend.
	self assert: promise waitForValue equals: nil
]
