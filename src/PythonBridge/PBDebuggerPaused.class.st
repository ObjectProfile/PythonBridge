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

{ #category : #exceptiondescription }
PBDebuggerPaused >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ UnhandledError signalForException: self
]

{ #category : #initialization }
PBDebuggerPaused >> setWaitAgain [
	"Flag the receiver's promise that it should wait for another value"

	promise setWaitAgain.
]
