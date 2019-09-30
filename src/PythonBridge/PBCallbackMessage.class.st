Class {
	#name : #PBCallbackMessage,
	#superclass : #PBRSyncMessage,
	#instVars : [
		'commandId',
		'observerId',
		'value'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBCallbackMessage class >> type [
	^ #CALLBACK
]

{ #category : #accessing }
PBCallbackMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
PBCallbackMessage >> observerId [
	^ observerId
]

{ #category : #'as yet unclassified' }
PBCallbackMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	observerId := dict at: #observerId.
	value := dict at: #value
]

{ #category : #accessing }
PBCallbackMessage >> value [
	^ value
]
