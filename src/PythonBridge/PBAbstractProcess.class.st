Class {
	#name : #PBAbstractProcess,
	#superclass : #Object,
	#instVars : [
		'pythonMainFile',
		'settings',
		'workingDirectory'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBAbstractProcess class >> application: application [
	^ self 
		settings: application settings 
		workingDirectory: (PBPlatform current folderForApplication: application)
]

{ #category : #accessing }
PBAbstractProcess class >> platform [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractProcess class >> settings: settings application: application [
	^ self settings: settings workingDirectory: (PBPlatform current folderForApplication: application)
]

{ #category : #accessing }
PBAbstractProcess class >> settings: settings workingDirectory: fileRef [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		yourself
]

{ #category : #hooks }
PBAbstractProcess class >> workingDirectory [
	^ self platform folderForApplication: PBApplication
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
	^ settings
]

{ #category : #accessing }
PBAbstractProcess >> settings: anObject [
	settings := anObject
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
	^ workingDirectory
]

{ #category : #accessing }
PBAbstractProcess >> workingDirectory: anObject [
	workingDirectory := anObject
]
