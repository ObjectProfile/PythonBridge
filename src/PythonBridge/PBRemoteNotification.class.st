Class {
	#name : #PBRemoteNotification,
	#superclass : #Notification,
	#instVars : [
		'promise'
	],
	#category : #'PythonBridge-ErrorHandling'
}

{ #category : #accessing }
PBRemoteNotification >> promise [
	^ promise
]

{ #category : #accessing }
PBRemoteNotification >> promise: anObject [
	promise := anObject
]
