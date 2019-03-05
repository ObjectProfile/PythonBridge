Class {
	#name : #PBPipenvPyStrategy,
	#superclass : #PBPyProcessStrategy,
	#classVars : [
		'PipEnvPath'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBPipenvPyStrategy class >> pipEnvPath [
	^ PipEnvPath ifNil: [ PipEnvPath := self resolvePipenvPath ]
]

{ #category : #accessing }
PBPipenvPyStrategy class >> pipEnvPath: anObject [
	PipEnvPath := anObject
]

{ #category : #'as yet unclassified' }
PBPipenvPyStrategy class >> prepare [
	PBCommunicationHandler pythonPortGenerator: [ 7100 + 99 atRandom ].
	PBCommunicationHandler pharoPortGenerator: [ 7200 + 99 atRandom ]
]

{ #category : #'as yet unclassified' }
PBPipenvPyStrategy class >> resolvePipenvPath [
	^ (OSSUnixSubprocess new
				command: '/usr/bin/which';
				arguments: (Array with: 'pipenv');
				redirectStdout;
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]) 
					ifEmpty: [ self signalPipenvNotFound ]
]

{ #category : #'as yet unclassified' }
PBPipenvPyStrategy class >> signalPipenvNotFound [
	"
	PythonBridge use the unix command `which` to find the route of the `pipenv` command. From Pharo
	we could not find the route, therefore you have to set it mannualy.
		
	To find the path of Pipenv in your system run the command `which pipenv` in the terminal.
	To set the path in PythonBridge send the following message:
	
	PBProcessHandler pipEnvPath: '/PATH/TO/PIPENV/BINARY'
	
	"
	Error signal: 'Error: Pipenv command could not be found.'
]

{ #category : #'process spawning' }
PBPipenvPyStrategy >> arguments [
	^ { 'run'. 'python'. 'start_bridge.py'. 
		'--port'. self pythonPort asString . 
		'--pharo'. self pharoPort asString }
]

{ #category : #'process spawning' }
PBPipenvPyStrategy >> newProcess [
	^ OSSUnixSubprocess new
				command: self class pipEnvPath;
				arguments: self arguments;
				workingDirectory: self workingDirectory fullName;
				addAllEnvVariablesFromParentWithoutOverride;
				environmentAt: 'LC_ALL' put: 'en_US.UTF-8';
				environmentAt: 'LANG' put: 'en_US.UTF-8';
				redirectStdin;
				redirectStdout;
				redirectStderr;
				terminateOnShutdown;
				yourself
]

{ #category : #'process spawning' }
PBPipenvPyStrategy >> start [
	process := self newProcess.
	process run
]

{ #category : #'process spawning' }
PBPipenvPyStrategy >> stop [
	process ifNil: [ ^ self ].
	process isRunning ifTrue: [ process terminate ].
	process closeAndCleanStreams
]
