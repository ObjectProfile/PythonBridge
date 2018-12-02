Class {
	#name : #PBProcessHandler,
	#superclass : #PBHandler,
	#instVars : [
		'process'
	],
	#classVars : [
		'PipEnvPath',
		'PythonPath'
	],
	#category : #PythonBridge
}

{ #category : #'as yet unclassified' }
PBProcessHandler class >> pipEnvPath [
	^ PipEnvPath ifNil: [ PipEnvPath := self resolvePipenvPath ]
]

{ #category : #'as yet unclassified' }
PBProcessHandler class >> pipEnvPath: path [
	PipEnvPath := path
]

{ #category : #'as yet unclassified' }
PBProcessHandler class >> resolvePipenvPath [
	^ OSSUnixSubprocess new
				command: '/usr/bin/which';
				arguments: (Array with: 'pipenv');
				redirectStdout;
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command :outString | ^ outString trim ].
]

{ #category : #accessing }
PBProcessHandler >> arguments [
	^ { 'run'. 'python'. 'pharo_hooks.py'. 
		'--port'. self communicationHandler pythonPort asString . 
		'--pharo'. self communicationHandler pharoPort asString}
]

{ #category : #'as yet unclassified' }
PBProcessHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'instance creation' }
PBProcessHandler >> newProcess [
	^ OSSUnixSubprocess new
				command: self class pipEnvPath;
				arguments: self arguments;
				redirectStdin;
				redirectStdout;
				redirectStderr;
				terminateOnShutdown;
				yourself
]

{ #category : #accessing }
PBProcessHandler >> start [
	process := self newProcess.
	process run
]
