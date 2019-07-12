Class {
	#name : #PBCallbackAnswer,
	#superclass : #PBAnswer,
	#instVars : [
		'val'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBCallbackAnswer class >> type [
	^ 'CALLBACK'
]

{ #category : #accessing }
PBCallbackAnswer class >> val: aValue [
	^ self new
		val: aValue;
		yourself
]

{ #category : #encoding }
PBCallbackAnswer >> privateEncode: dict [
	dict at: #val put: val
]

{ #category : #accessing }
PBCallbackAnswer >> val [
	^ val
]

{ #category : #accessing }
PBCallbackAnswer >> val: anObject [
	val := anObject
]
