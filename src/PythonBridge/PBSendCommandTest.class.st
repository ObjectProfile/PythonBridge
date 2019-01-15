Class {
	#name : #PBSendCommandTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSendCommandTest >> testAddBinding [
	| binding |
	binding := PBBinding wrap: #((2) 3).
	self cf addBinding: binding.
	self cf << binding.
	self assert: self cfSend waitForValue equals: #((2) 3)
]

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
