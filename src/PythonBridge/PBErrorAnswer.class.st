Class {
	#name : #PBErrorAnswer,
	#superclass : #PBRAnswer,
	#instVars : [
		'handlingAction'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBErrorAnswer >> handlingAction [
	^ handlingAction
]

{ #category : #accessing }
PBErrorAnswer >> handlingAction: anObject [
	handlingAction := anObject
]

{ #category : #encoding }
PBErrorAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #action put: handlingAction encodeAsDictionary
]
