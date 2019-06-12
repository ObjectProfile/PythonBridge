Class {
	#name : #PBErrorAnswer,
	#superclass : #PBAnswer,
	#instVars : [
		'handlingAction'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #'as yet unclassified' }
PBErrorAnswer class >> handlingAction: action [
	^ self new
		handlingAction: action;
		yourself
]

{ #category : #accessing }
PBErrorAnswer class >> type [
	^ 'ERR'
]

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
	dict at: #handlingAction put: handlingAction encodeAsDictionary
]
