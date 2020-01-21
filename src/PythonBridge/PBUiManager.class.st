Class {
	#name : #PBUiManager,
	#superclass : #Object,
	#category : #'PythonBridge-Platform'
}

{ #category : #hooks }
PBUiManager >> notify: aString [
	self subclassResponsibility
]

{ #category : #hooks }
PBUiManager >> spawnDebuggerOnException: anException [
	self subclassResponsibility
]
