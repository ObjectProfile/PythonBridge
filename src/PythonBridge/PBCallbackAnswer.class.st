Class {
	#name : #PBCallbackAnswer,
	#superclass : #PBRAnswer,
	#instVars : [
		'value'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #encoding }
PBCallbackAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #value put: value
]

{ #category : #accessing }
PBCallbackAnswer >> value [
	^ value
]

{ #category : #accessing }
PBCallbackAnswer >> value: anObject [
	value := anObject
]
