Class {
	#name : #PBPythonProcessError,
	#superclass : #Error,
	#instVars : [
		'application',
		'process'
	],
	#category : #'PythonBridge-ErrorHandling'
}

{ #category : #accessing }
PBPythonProcessError >> application [
	^ application
]

{ #category : #accessing }
PBPythonProcessError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PBPythonProcessError >> description [ 

	^ String streamContents: [ :stream |
		self printOn: stream ]
]

{ #category : #printing }
PBPythonProcessError >> printOn: aStream [

	aStream
		<< 'Python process error'; cr;
		<< '===================='; cr;
		cr.
	messageText ifNotNil: 
		[ aStream << messageText; cr ].
	aStream cr.
	application pythonServerStatusOn: aStream process: process
]

{ #category : #accessing }
PBPythonProcessError >> process [
	^ process
]

{ #category : #accessing }
PBPythonProcessError >> process: anObject [
	process := anObject
]
