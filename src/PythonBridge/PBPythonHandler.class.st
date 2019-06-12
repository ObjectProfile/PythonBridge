Class {
	#name : #PBPythonHandler,
	#superclass : #PBHandler,
	#instVars : [
		'process'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #initialization }
PBPythonHandler >> initializeHandler [
	super initializeHandler.
	process := PBPlatform current processClass application: self application
]

{ #category : #testing }
PBPythonHandler >> isRunning [
	^ process isRunning
]

{ #category : #testing }
PBPythonHandler >> start [
	^ process start
]

{ #category : #testing }
PBPythonHandler >> stop [
	^ process stop
]
