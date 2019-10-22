Class {
	#name : #PBAbstractAnswer,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #'instance creation' }
PBAbstractAnswer class >> answerFor: aMessage [
	^ self new
		message: aMessage;
		yourself
]

{ #category : #accessing }
PBAbstractAnswer >> message [
	^ message
]

{ #category : #accessing }
PBAbstractAnswer >> message: anObject [
	message := anObject
]

{ #category : #accessing }
PBAbstractAnswer >> type [
	^ message type
]
