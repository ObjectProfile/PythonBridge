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

{ #category : #testing }
PBRMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ true
]

{ #category : #accessing }
PBRMessage class >> type [
	^ #RMSG
]

{ #category : #'as yet unclassified' }
PBRMessage >> privateDecode: aDict [
]
