Class {
	#name : #PBPharoUiManager,
	#superclass : #PBUiManager,
	#category : #'PythonBridge-Pharo-Platform'
}

{ #category : #'as yet unclassified' }
PBPharoUiManager >> notify: aString [
	Warning signal: aString
]

{ #category : #hooks }
PBPharoUiManager >> spawnDebuggerOnException: anException [
	^ UnhandledError signalForException: anException
]
