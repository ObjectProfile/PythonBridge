Class {
	#name : #PBUpdatePromiseMessage,
	#superclass : #PBRAsyncMessage,
	#instVars : [
		'promiseId',
		'value'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBUpdatePromiseMessage class >> type [
	^ #EVAL
]

{ #category : #'as yet unclassified' }
PBUpdatePromiseMessage >> privateDecode: dict [
	super privateDecode: dict.
	promiseId := dict at: #id.
	value := dict at: #value
]

{ #category : #accessing }
PBUpdatePromiseMessage >> promiseId [
	^ promiseId
]

{ #category : #accessing }
PBUpdatePromiseMessage >> value [
	^ value
]
