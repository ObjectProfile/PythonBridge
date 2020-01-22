Class {
	#name : #PBAbstractProcess,
	#superclass : #Object,
	#instVars : [
		'pythonMainFile',
		'debugMode',
		'settings',
		'workingDirectory'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBAbstractProcess class >> application: application [
	^ self 
		settings: application settings 
		application: application
]

{ #category : #accessing }
PBAbstractProcess class >> platform [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractProcess class >> settings: settings application: application [
	^ self 
		settings: settings 
		workingDirectory: (PBPlatform current folderForApplication: application)
		debugMode: application class debugMode
]

{ #category : #accessing }
PBAbstractProcess class >> settings: settings workingDirectory: fileRef [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		yourself
]

{ #category : #accessing }
PBAbstractProcess class >> settings: settings workingDirectory: fileRef debugMode: flag [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		debugMode: flag;
		yourself
]

{ #category : #hooks }
PBAbstractProcess class >> workingDirectory [
	^ self platform folderForApplication: PBApplication
]

{ #category : #accessing }
PBAbstractProcess >> debugMode [
	^ debugMode
]

{ #category : #accessing }
PBAbstractProcess >> debugMode: anObject [
	debugMode := anObject
]

{ #category : #accessing }
PBAbstractProcess >> errorMessage [
	self subclassResponsibility
]

{ #category : #initialization }
PBAbstractProcess >> initialize [
	super initialize.
	debugMode := false
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
