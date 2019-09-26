Class {
	#name : #PBCallbackAnswerOld,
	#superclass : #PBOldAnswer,
	#instVars : [
		'val'
	],
	#category : #'PythonBridge-Platform-Messages-Old'
}

{ #category : #accessing }
PBCallbackAnswerOld class >> type [
	^ 'CALLBACK'
]

{ #category : #accessing }
PBCallbackAnswerOld class >> val: aValue [
	^ self new
		val: aValue;
		yourself
]

{ #category : #encoding }
PBCallbackAnswerOld >> privateEncode: dict [
	dict at: #val put: val
]

{ #category : #accessing }
PBCallbackAnswerOld >> val [
	^ val
]

{ #category : #accessing }
PBCallbackAnswerOld >> val: anObject [
	val := anObject
]
