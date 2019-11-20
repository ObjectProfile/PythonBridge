Class {
	#name : #PBPharoUiManager,
	#superclass : #PBUiManager,
	#category : #'PythonBridge-Pharo-Platform'
}

{ #category : #'as yet unclassified' }
PBPharoUiManager >> notify: aString [
	Transcript show: aString asString.
	super notify: aString asString.
]

{ #category : #hooks }
PBPharoUiManager >> spawnDebuggerOnException: anException [
	^ UnhandledError signalForException: anException
]
