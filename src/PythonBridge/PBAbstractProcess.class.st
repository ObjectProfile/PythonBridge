Class {
	#name : #PBAbstractProcess,
	#superclass : #Object,
	#instVars : [
		'pythonMainFile',
		'workingDirectory',
		'application'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBAbstractProcess class >> application: application [
	^ self new application: application
]

{ #category : #accessing }
PBAbstractProcess class >> platform [
	self subclassResponsibility
]

{ #category : #hooks }
PBAbstractProcess class >> workingDirectory [

	self deprecated: 'This should be run against a PBApplication instance that knows its runtime directory'.
	"^ self platform runtimeFolderForApplication: PBApplication"
]

{ #category : #accessing }
PBAbstractProcess >> application [
	^ application
]

{ #category : #accessing }
PBAbstractProcess >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PBAbstractProcess >> debugMode [
	^ self settings debugMode
]

{ #category : #accessing }
PBAbstractProcess >> errorMessage [
	self subclassResponsibility
]

{ #category : #testing }
PBAbstractProcess >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractProcess >> pythonMainFile [
	^ pythonMainFile ifNil: [ self workingDirectory / 'start_bridge.py' ]
]

{ #category : #accessing }
PBAbstractProcess >> pythonMainFile: anObject [
	pythonMainFile := anObject
]

{ #category : #accessing }
PBAbstractProcess >> settings [
	^ application settings
]

{ #category : #'start-stop' }
PBAbstractProcess >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
PBAbstractProcess >> stop [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractProcess >> workingDirectory [
	^ application workingDirectory
]
