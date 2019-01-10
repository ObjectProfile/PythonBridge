Class {
	#name : #PBSerializationTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSerializationTest >> testSendAndRetrieveNil [
	self cf << nil.
	self cfSend.
	self assert: promise waitForValue equals: nil
]
