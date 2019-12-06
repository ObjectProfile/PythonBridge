Class {
	#name : #PBSerializationTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSerializationTest >> testSendAndRetrieveFloat [
	self cf << 2.2.
	self cfSend.
	self assert: promise waitForValue equals: 2.2.
]

{ #category : #tests }
PBSerializationTest >> testSendAndRetrieveInteger [
	self cf << 2.
	self cfSend.
	self assert: promise waitForValue equals: 2.
]

{ #category : #tests }
PBSerializationTest >> testSendAndRetrieveNil [
	self cf << nil.
	self cfSend.
	self assert: promise waitForValue equals: nil
]
