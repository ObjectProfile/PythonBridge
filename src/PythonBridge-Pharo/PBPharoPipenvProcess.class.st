Class {
	#name : #PBPharoPipenvProcess,
	#superclass : #PBAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables',
		'serverDebugger'
	],
	#classVars : [
		'PipenvPath'
	],
	#category : #'PythonBridge-Pharo-Processes'
}

{ #category : #'class initialization' }
PBPharoPipenvProcess class >> initialize [ 

	SessionManager default registerUserClassNamed: self name.
]

{ #category : #initialization }
PBPharoPipenvProcess class >> pipenvPath [
	^ PipenvPath 
			ifNil: [ PipenvPath := self resolvePipenvPath ]
			ifNotNil: [ PipenvPath ]
]

{ #category : #initialization }
PBPharoPipenvProcess class >> pipenvPath: aFileReference [
	PipenvPath := aFileReference
]

{ #category : #accessing }
PBPharoPipenvProcess class >> platform [
	^ PBPharoPlatform current
]

{ #category : #initialization }
PBPharoPipenvProcess class >> reset [ 
	<script>

	PipenvPath := nil.
]

{ #category : #initialization }
PBPharoPipenvProcess class >> resolvePipenvPath [
	| path |

	(OSSUnixSubprocess new
				command: '/usr/bin/which';
				arguments: (Array with: 'pipenv');
				addAllEnvVariablesFromParentWithoutOverride;
				redirectStdout;
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command :outString | path := outString trim ]).
	path ifEmpty: [ self signalPipenvNotFound ].
	^ path asFileReference
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

{ #category : #'system startup' }
PBPharoPipenvProcess class >> startUp: resuming [
	"On startup any instances saved during the last session will be invalid (since the processes are terminated on shutdown).  Mark them as stopped."

	resuming ifTrue: 
		[ self allInstancesDo: [ :each | each stop ] ]
]

{ #category : #'start-stop' }
PBPharoPipenvProcess >> debuggerStateChangedAction: aDAPThreadStateChanged [
	"Respond to the debugger state changed notification.
	Signal all promises that the debugger has been paused."

	aDAPThreadStateChanged isStopped ifTrue:
		[ self application notifyDebuggerPaused: serverDebugger ]
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

{ #category : #utils }
PBPharoPipenvProcess >> installModule: aString in: aPBApplication [
	"Install the supplied module using `pipenv run pip install aString`"
	| pipenvPath proc arguments stdoutStream stderrStream |

	pipenvPath := aPBApplication settings pipenvPath ifNil: [ self class pipenvPath ].
	arguments := { 'run'. 'pip'. 'install'. aString. }.
	stdoutStream := String new writeStream.
	stderrStream := String new writeStream.
	proc := OSSUnixSubprocess new
		command: pipenvPath fullName;
		arguments: arguments;
		workingDirectory: aPBApplication workingDirectory fullName;
		addAllEnvVariablesFromParentWithoutOverride;
		terminateOnShutdown;
		redirectStdout;
		redirectStderr;
		yourself.
	environmentVariables associationsDo: [ :assoc |
		proc environmentAt: assoc key put: assoc value ].
	proc run.
	proc
		waitForExitPollingEvery: (Delay forMilliseconds: 500)
		doing: [ :aProcess :outStream :errStream | 
			stdoutStream nextPutAll: outStream upToEnd.
			stderrStream nextPutAll: errStream upToEnd ].
	proc isSuccess ifFalse:
		[ self error: 'Unable to install module:', aString asString ].
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

	newProcess := GtUnixSubprocess new
				command: (self settings pipenvPath ifNil:
					[ self class pipenvPath ]) fullName;
				arguments: self processArguments;
				workingDirectory: self workingDirectory fullName;
				addAllEnvVariablesFromParentWithoutOverride;
				terminateOnShutdown;
				yourself.
	environmentVariables associationsDo: [ :assoc |
		newProcess environmentAt: assoc key put: assoc value ].
	^ newProcess
]

{ #category : #accessing }
PBPharoPipenvProcess >> pipenvPath [ 
	"Answer the default pipenvPath.
	This may be overridden by the application settings."

	^ self class pipenvPath
]

{ #category : #accessing }
PBPharoPipenvProcess >> process [
	^ process
]

{ #category : #private }
PBPharoPipenvProcess >> processArguments [
	| args |

	args := OrderedCollection new.
	args
		add: 'run';
		add: 'python'.
	self settings serverDebugMode ifTrue:
		[ args addAll: { 
			'-m'. 
			'debugpy'. 
			'--listen'. 
			self settings debugSocketAddress printAddress. 
			'--wait-for-client'. } ].
	args
		add: self pythonMainFile fullName;
		add: '--port';
		add: self settings pythonSocketAddress port asString;
		add: '--pharo';
		add: self settings pharoSocketAddress port asString;
		add: '--method';
		add: PBPlatform current messageBrokerStrategy pythonMethodArg.
	self debugMode ifTrue: [ args add: '--log' ].
	^ args
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

	process run.
	self settings serverDebugMode ifTrue:
		[ self startServerDebugger ].
]

{ #category : #'start-stop' }
PBPharoPipenvProcess >> startServerDebugger [
	"Start the debugger, tell the server to run and set up inspection on halt"

	"Give the server time to start"
	1 second wait.
	serverDebugger := DAPPythonDebugger new 
		localRoot: self workingDirectory;
		connectTo: #[127 0 0 1] port: self settings debugSocketAddress port.
	serverDebugger announcer 
		when: DAPThreadStateChanged 
		do: [ :announcement | self debuggerStateChangedAction: announcement ].

]

{ #category : #accessing }
PBPharoPipenvProcess >> stderr [
	"Answer the process stderr contents"

	^ process stderr
]

{ #category : #accessing }
PBPharoPipenvProcess >> stdout [ 
	"Answer the process stdout contents"

	^ process stdout
]

{ #category : #'start-stop' }
PBPharoPipenvProcess >> stop [
	process ifNil: [ ^ self ].
	[ process queryExitStatus ifNil: [ process terminate ]] 
		on: Error 
		do: [ :e | "Do nothing."].
	process closeAndCleanStreams.
	process := nil.
]

{ #category : #'start-stop' }
PBPharoPipenvProcess >> stopServerDebugger [
	"Close the debugger and deregister"

	serverDebugger close.
	serverDebugger announcer unsubscribe: self debuggerStateChangedAction
]
