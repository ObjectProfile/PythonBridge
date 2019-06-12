Class {
	#name : #PBPythonHandlerOLD,
	#superclass : #PBHandler,
	#instVars : [
		'processStrategy'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBPythonHandlerOLD class >> pipEnvPath [
	^ PipEnvPath ifNil: [ PipEnvPath := self resolvePipenvPath ]
]

{ #category : #'as yet unclassified' }
PBPythonHandlerOLD class >> pipEnvPath: path [
	PipEnvPath := path
]

{ #category : #'as yet unclassified' }
PBPythonHandlerOLD class >> resolvePipenvPath [
	^ (OSSUnixSubprocess new
				command: '/usr/bin/which';
				arguments: (Array with: 'pipenv');
				redirectStdout;
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]) 
					ifEmpty: [ self signalPipenvNotFound ]
]

{ #category : #'as yet unclassified' }
PBPythonHandlerOLD class >> signalPipenvNotFound [
	"
	PythonBridge use the unix command `which` to find the route of the `pipenv` command. From Pharo
	we could not find the route, therefore you have to set it mannualy.
		
	To find the path of Pipenv in your system run the command `which pipenv` in the terminal.
	To set the path in PythonBridge send the following message:
	
	PBProcessHandler pipEnvPath: '/PATH/TO/PIPENV/BINARY'
	
	"
	Error signal: 'Error: Pipenv command could not be found.'
]

{ #category : #'as yet unclassified' }
PBPythonHandlerOLD >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #testing }
PBPythonHandlerOLD >> errorMessage [
	^ self processStrategy errorMessage
]

{ #category : #accessing }
PBPythonHandlerOLD >> initializeHandler [
	super initializeHandler.
	processStrategy := PBPyProcessStrategy default
									workingDirectory: self application class repositoryFileReference
									pharoPort: self communicationHandler pharoPort
									pythonPort: self communicationHandler pythonPort
]

{ #category : #testing }
PBPythonHandlerOLD >> isRunning [
	^ self processStrategy isRunning
]

{ #category : #accessing }
PBPythonHandlerOLD >> processStrategy [
	^ processStrategy
]

{ #category : #accessing }
PBPythonHandlerOLD >> processStrategy: anObject [
	processStrategy := anObject
]

{ #category : #accessing }
PBPythonHandlerOLD >> start [
	OSPlatform current isWindows ifFalse: [ 
		self application class createSymlinkFolder.
		self application class ensurePythonBridgeSymlink. ].
	^ self processStrategy start
]

{ #category : #accessing }
PBPythonHandlerOLD >> stop [
	^ self processStrategy stop
]
