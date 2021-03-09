Class {
	#name : #PBDebuggerPaused,
	#superclass : #PBRemoteNotification,
	#instVars : [
		'debugger'
	],
	#category : #'PythonBridge-ErrorHandling'
}

{ #category : #accessing }
PBDebuggerPaused >> debugger [
	^ debugger
]

{ #category : #accessing }
PBDebuggerPaused >> debugger: anObject [
	debugger := anObject
]
