Class {
	#name : #PBPythonError,
	#superclass : #Notification,
	#instVars : [
		'command',
		'errorMessage',
		'application',
		'proceedAction',
		'trace'
	],
	#category : #'PythonBridge-ErrorHandling'
}

{ #category : #accessing }
PBPythonError >> application [
	^ application
]

{ #category : #accessing }
PBPythonError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PBPythonError >> command [
	^ command
]

{ #category : #accessing }
PBPythonError >> command: anObject [
	command := anObject
]

{ #category : #accessing }
PBPythonError >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ UIManager default unhandledErrorDefaultAction: self
]

{ #category : #'as yet unclassified' }
PBPythonError >> defaultProceedAction [
	^ PBDropQueue new
]

{ #category : #accessing }
PBPythonError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
PBPythonError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #initialization }
PBPythonError >> initialize [
	super initialize.
	proceedAction := self defaultProceedAction
]

{ #category : #accessing }
PBPythonError >> isResumable [
	^ true
]

{ #category : #accessing }
PBPythonError >> messageText [
	^ errorMessage
]

{ #category : #accessing }
PBPythonError >> proceedAction [
	^ proceedAction
]

{ #category : #accessing }
PBPythonError >> proceedAction: anObject [
	proceedAction := anObject
]

{ #category : #tracing }
PBPythonError >> trace [
	^ trace
]

{ #category : #tracing }
PBPythonError >> trace: aTrace [
	trace := aTrace
]
