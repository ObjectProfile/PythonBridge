Class {
	#name : #PBHandler,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBHandler class >> application: anApplication [
	^ self new
		application: anApplication;
		initializeHandler;
		yourself
]

{ #category : #accessing }
PBHandler >> application [
	^ application
]

{ #category : #accessing }
PBHandler >> application: anObject [
	application := anObject
]

{ #category : #initialization }
PBHandler >> initializeHandler [
]

{ #category : #testing }
PBHandler >> isRunning [
	^ true
]

{ #category : #accessing }
PBHandler >> start [
]

{ #category : #accessing }
PBHandler >> stop [
]
