Class {
	#name : #PBErrorAnswerOl,
	#superclass : #PBOldAnswer,
	#instVars : [
		'handlingAction'
	],
	#category : #'PythonBridge-Platform-Messages-Old'
}

{ #category : #'as yet unclassified' }
PBErrorAnswerOl class >> handlingAction: action [
	^ self new
		handlingAction: action;
		yourself
]

{ #category : #accessing }
PBErrorAnswerOl class >> type [
	^ 'ERR'
]

{ #category : #accessing }
PBErrorAnswerOl >> handlingAction [
	^ handlingAction
]

{ #category : #accessing }
PBErrorAnswerOl >> handlingAction: anObject [
	handlingAction := anObject
]

{ #category : #encoding }
PBErrorAnswerOl >> privateEncode: dict [
	dict addAll: handlingAction encodeAsDictionary
]
