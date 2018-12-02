Class {
	#name : #PBHandler,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#category : #PythonBridge
}

{ #category : #'as yet unclassified' }
PBHandler class >> application: anApplication [
	^ self new
		application: anApplication;
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
