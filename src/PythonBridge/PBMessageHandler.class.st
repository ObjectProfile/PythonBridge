Class {
	#name : #PBMessageHandler,
	#superclass : #Object,
	#instVars : [
		'message',
		'callback'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBMessageHandler class >> forMessage: msg callback: block [
	^ (self handlerClassForMessage: msg) new
		message: msg;
		callback: block;
		yourself
]

{ #category : #'as yet unclassified' }
PBMessageHandler class >> handlerClassForMessage: msg [
	^ msg isSync
		ifTrue: [ PBSyncMessageHandler ]
		ifFalse: [ PBAsyncMessageHandler ]
]

{ #category : #accessing }
PBMessageHandler >> callback [
	^ callback
]

{ #category : #accessing }
PBMessageHandler >> callback: anObject [
	callback := anObject
]

{ #category : #accessing }
PBMessageHandler >> handleMessage [
	callback value: message
]

{ #category : #accessing }
PBMessageHandler >> message [
	^ message
]

{ #category : #accessing }
PBMessageHandler >> message: anObject [
	message := anObject
]

{ #category : #asserting }
PBMessageHandler >> shouldAnswer [
	^ false
]
