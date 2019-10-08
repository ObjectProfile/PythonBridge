Class {
	#name : #PBPharoPipenvProcess,
	#superclass : #PBAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables'
	],
	#classVars : [
		'PipenvPath'
	],
	#category : #'PythonBridge-Pharo-Processes'
}

{ #category : #initialization }
PBPharoPipenvProcess class >> pipenvPath [
	^ PipenvPath isEmptyOrNil 
			ifTrue: [ PipenvPath := self resolvePipenvPath ]
			ifFalse: [ PipenvPath ]
]

{ #category : #initialization }
PBPharoPipenvProcess class >> pipenvPath: aString [
	PipenvPath := aString
]

{ #category : #accessing }
PBPharoPipenvProcess class >> platform [
	^ PBPharoPlatform current
]

{ #category : #initialization }
PBPharoPipenvProcess class >> resolvePipenvPath [
	^ (OSSUnixSubprocess new
				command: '/usr/bin/which';
				arguments: (Array with: 'pipenv');
				addAllEnvVariablesFromParentWithoutOverride;
				redirectStdout;
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]) 
					ifEmpty: [ self signalPipenvNotFound ]
]

{ #category : #initialization }
PBPharoPipenvProcess class >> signalPipenvNotFound [
	"
	PythonBridge use the unix command `which` to find the route of the `pipenv` command. From Pharo
	we could not find the route, therefore you have to set it mannualy.
		
	To find the path of Pipenv in your system run the command `which pipenv` in the terminal.
	To set the path in PythonBridge send the following message:
	
	PBProcessHandler pipEnvPath: '/PATH/TO/PIPENV/BINARY'
	
	"
	Error signal: 'Error: Pipenv command could not be found.'
]

{ #category : #accessing }
PBPharoPipenvProcess >> environmentVariables [
	^ environmentVariables
]

{ #category : #accessing }
PBPharoPipenvProcess >> errorMessage [
	^ process stderrStream contents
]

{ #category : #initialization }
PBPharoPipenvProcess >> initialize [
	super initialize.
	environmentVariables := Dictionary new.
	self setDefaultEnvironmentVariables
]

{ #category : #testing }
PBPharoPipenvProcess >> isRunning [
	^ process
		ifNil: [ false ]
		ifNotNil: [ process isRunning ]
]

{ #category : #private }
PBPharoPipenvProcess >> newProcess [
	| newProcess |
	newProcess := OSSUnixSubprocess new
				command: self class pipenvPath;
				arguments: self processArguments;
				workingDirectory: self workingDirectory fullName;
				addAllEnvVariablesFromParentWithoutOverride;
				redirectStdout;
				redirectStderr;
				terminateOnShutdown;
				yourself.
	environmentVariables associationsDo: [ :assoc |
		newProcess environmentAt: assoc key put: assoc value ].
	^ newProcess
]

{ #category : #accessing }
PBPharoPipenvProcess >> process [
	^ process
]

{ #category : #private }
PBPharoPipenvProcess >> processArguments [
	^ { 
			'run'. 
			'python'. self pythonMainFile fullName. 
			'--port'. self settings pythonSocketAddress port asString . 
			'--pharo'. self settings pharoSocketAddress port asString .
			'--log'}
]

{ #category : #initialization }
PBPharoPipenvProcess >> setDefaultEnvironmentVariables [
	environmentVariables
		at: 'LC_ALL' put: 'en_US.UTF-8';
		at: 'LANG' put: 'en_US.UTF-8';
		at: 'PIPENV_VENV_IN_PROJECT' put: '1';
		at: 'PIP_DEFAULT_TIMEOUT' put: '100'
]

{ #category : #'start-stop' }
PBPharoPipenvProcess >> start [
	process := self newProcess.
	process run
]

{ #category : #'start-stop' }
PBPharoPipenvProcess >> stop [
	process ifNil: [ ^ self ].
	process isRunning ifTrue: [ process terminate ].
	process closeAndCleanStreams
]
