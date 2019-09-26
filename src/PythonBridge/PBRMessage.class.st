Class {
	#name : #PBRMessage,
	#superclass : #PBAbstractMessage,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #actions }
PBRMessage class >> decodeFrom: aDict [
	^ self new
		privateDecode: aDict;
		yourself
]

{ #category : #'as yet unclassified' }
PBRMessage >> privateDecode: aDict [
]
