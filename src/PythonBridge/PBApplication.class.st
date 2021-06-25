Class {
	#name : #PBApplication,
	#superclass : #Object,
	#instVars : [
		'communicationHandler',
		'processHandler',
		'loggingHandler',
		'executionHandler',
		'settings'
	],
	#classVars : [
		'DebugMode'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'PythonBridge-Global'
}

{ #category : #accessing }
PBApplication class >> baseApplication [
	^ PBApplication
]

{ #category : #debug }
PBApplication class >> debugMode [
	^ DebugMode ifNil: [ false ]
]

{ #category : #debug }
PBApplication class >> debugMode: bool [
	^ DebugMode := bool
]

{ #category : #'start-stop' }
PBApplication class >> do: aBlockClosure [ 
	| retVal |
	self isRunning ifTrue: [ ^ aBlockClosure value ].
	[
		self start.
		retVal := aBlockClosure cull: self uniqueInstance.
		self uniqueInstance commandFactory << nil.
		self uniqueInstance commandFactory send waitForValue. ] ensure: [ self stop ].
	^ retVal
]

{ #category : #initialization }
PBApplication class >> initialize [
	SessionManager default registerToolClassNamed: self name
]

{ #category : #testing }
PBApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
]

{ #category : #'start-stop' }
PBApplication class >> killAll [
	"Stop ALL PBApplication instances and kill any server processes that may still be running."
	| allInstances firstApplication wd proc error |

	allInstances := self allInstances.
	allInstances ifEmpty: [ ^ self ].
	firstApplication := allInstances
		detect: #isRunning 
		ifNone: [ allInstances first ].
	allInstances do: #stop.
	wd := firstApplication workingDirectory.
	proc := PBUnixSubprocess new command: (wd / 'killpbservers.sh') fullName.
	proc runAndWait.
	proc isSuccess ifFalse: 
		[ error:= PBPythonProcessError new
		application: firstApplication;
		process: proc.
		error signal ].
	self assert: proc stderr trimBoth isEmpty.
	^ proc stdout
]

{ #category : #testing }
PBApplication class >> module [
	^ self uniqueInstance module
]

{ #category : #'pipenv setup' }
PBApplication class >> platform [
	^ PBPlatform current
]

{ #category : #'python hooks file' }
PBApplication class >> repositoryFileReference [

	self deprecated: 'This should be run against a PBApplication instance that knows its runtime directory'.
	"^ self platform runtimeFolderForApplication: self"
]

{ #category : #instructions }
PBApplication class >> resetUniqueInstance [
	uniqueInstance ifNotNil: [ 
		[ uniqueInstance stop ] 
			on: Error 
			do: [ PBPlatform current uiManager inform: 'Error on reseting unique instance.' ]. ].
	uniqueInstance := nil
]

{ #category : #accessing }
PBApplication class >> runtimeDirectory [
	"This is the directory basename where the runtime files are located"

	^ 'PythonBridgeRuntime'
]

{ #category : #instructions }
PBApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
]

{ #category : #accessing }
PBApplication class >> shutdown: isImageQuitting [
	isImageQuitting ifTrue: [ self stop ]
]

{ #category : #'start-stop' }
PBApplication class >> start [
	self isRunning ifTrue: [ Error signal: 'Keras already running.' ].
	self stop.
	uniqueInstance := self new.
	PBCF reset.
	uniqueInstance commandFactory reset.
	uniqueInstance start
]

{ #category : #'start-stop' }
PBApplication class >> stop [
	uniqueInstance ifNotNil: [ 
		uniqueInstance stop. ].
	uniqueInstance := nil
]

{ #category : #testing }
PBApplication class >> test [ 
	self assert: (self do: [ :app |
		app commandFactory << (P3GBinaryOperator new
                     left: 1;
                     right: 2;
                     operator: $+;
                     yourself).
		app commandFactory send waitForValue
	  ]) = 3
]

{ #category : #instructions }
PBApplication class >> uniqueInstance [
	uniqueInstance ifNil: [ self start ].
	^ uniqueInstance
]

{ #category : #accessing }
PBApplication class >> uniqueInstance: anObject [
	uniqueInstance := anObject
]

{ #category : #utils }
PBApplication >> addMapping: pythonType to: pythonFunction [
	self commandFactory 
		send: (#bridge_globals asP3GI => #msg_service => #addMapping 
						callWith: (Array with: pythonType with: pythonFunction))
]

{ #category : #accessing }
PBApplication >> commandFactory [
	^ PBCF
]

{ #category : #accessing }
PBApplication >> communicationHandler [
	^ communicationHandler
]

{ #category : #accessing }
PBApplication >> errorMessage [
	"Fetch the error message from the stderr stream, from the processhander"

	^ self serverStatus
]

{ #category : #accessing }
PBApplication >> executionHandler [
	^ executionHandler
]

{ #category : #ui }
PBApplication >> gtSettingsFor: aView [
	<gtView>

	^ aView forward 
		title: 'Settings';
		priority: 60;
		object: [ settings ];
		view: #gtSettingsFor:
]

{ #category : #ui }
PBApplication >> gtStatusFor: aView [
	<gtView>

	^ aView textEditor 
		title: 'Status';
		priority: 50;
		text: [ self serverStatus asRopedText glamorousCodeFont ]
]

{ #category : #handlers }
PBApplication >> handlers [
	^ Array
		with: loggingHandler
		with: communicationHandler
		with: processHandler
		with: executionHandler
]

{ #category : #initialization }
PBApplication >> initialize [
	super initialize.
	settings := PBPlatform current defaultSettings.
	self initializeHandlers.
]

{ #category : #initialization }
PBApplication >> initializeHandlers [
	loggingHandler := PBLoggingHandler application: self.
	communicationHandler := PBCommunicationHandler application: self.
	processHandler := PBPythonHandler application: self.
	executionHandler := PBExecutionHandler application: self
]

{ #category : #utils }
PBApplication >> installModule: aString [
	"Install the supplied module using `pipenv run pip install aString`"

	PBPharoPipenvProcess new installModule: aString in: self
]

{ #category : #testing }
PBApplication >> isPythonReady [
	"Ensures python webserver is ready for receiving commands"
	^ self communicationHandler isPythonReady
]

{ #category : #testing }
PBApplication >> isRunning [
	^ self handlers allSatisfy: #isRunning
]

{ #category : #logging }
PBApplication >> log: aLog [
	self loggingHandler log: aLog
]

{ #category : #accessing }
PBApplication >> loggingHandler [
	^ loggingHandler
]

{ #category : #accessing }
PBApplication >> module [
	self subclassResponsibility
]

{ #category : #'instance creation' }
PBApplication >> newCommandFactory [
	^ self executionHandler newCommandFactory
]

{ #category : #'instance creation' }
PBApplication >> newCommandStringFactory [
	^ self executionHandler newCommandStringFactory
]

{ #category : #instructions }
PBApplication >> notifyDebuggerPaused: aDebugger [
	"Notify all promises that the server debugger has paused in case the Bloc UI process is waiting on one of the promises."

	self executionHandler notifyDebuggerPaused: aDebugger.
]

{ #category : #accessing }
PBApplication >> pipenvPath [ 
	"Answer the pipenvPath to be used for this application"

	^ settings pipenvPath ifNil: [ processHandler pipenvPath ]
]

{ #category : #accessing }
PBApplication >> postInitialization [
	
]

{ #category : #printing }
PBApplication >> printOn: aStream [

	aStream
		<< self class name;
		<< '('.
	self isRunning ifFalse:
		[ aStream << 'not running)'.
		^ self ].
	aStream
		print: settings pharoSocketAddress;
		<< ', ';
		print: settings pythonSocketAddress;
		<< ')'
]

{ #category : #accessing }
PBApplication >> processHandler [
	^ processHandler
]

{ #category : #utils }
PBApplication >> registerObject: aPythonObject [
	self executionHandler registerObject: aPythonObject
]

{ #category : #accessing }
PBApplication >> runtimeDirectory [
	"This is the directory basename where the runtime files are located"

	^ self class runtimeDirectory
]

{ #category : #instructions }
PBApplication >> send: aCommand [
	self isRunning ifFalse: [ Error signal: 'Bridge not running.' ].
	^ executionHandler sendCommand: aCommand
]

{ #category : #'start-stop' }
PBApplication >> serverStatus [
	"Answer a string describing the environment and server status.
	Mostly for problem solving."

	^ String streamContents: [ :stream |
		self serverStatusOn: stream process: processHandler ]
]

{ #category : #'start-stop' }
PBApplication >> serverStatusOn: aStream process: process [
	"Write the environment and server status on the supplied stream.
	Mostly for problem solving."
	| serverPathString |

	serverPathString := [ self pipenvPath isExecutable
		ifTrue: [ self pipenvPath fullName ]
		ifFalse: [ self pipenvPath fullName, ': doesn''t exist or isn''t executable, it should be in the PATH' ] ]
			on: Error
			do: [ '<Unable to determine server path.  It should be in the PATH>' ].

	aStream
		<< 'Running:           ';
			print: self isRunning; cr;
		<< 'pipenv:            ';
			<< serverPathString; cr;
		<< 'Working directory: ';
			<< self workingDirectory fullName; cr;
		<< 'Server running:    ';
			print: process isRunning; cr.
	process hasProcess ifFalse: [ ^ self ].
	process isRunning ifFalse: 
		[ aStream
			<< 'exit status:       ';
				print: process exitStatusInterpreter exitStatus; cr ].
	aStream
		cr; cr;
		<< 'Stdout:'; cr;
			<< process stdout; cr;
		cr; cr;
		<< 'Stderr:'; cr;
			<< process stderr.
]

{ #category : #accessing }
PBApplication >> settings [
	^ settings
]

{ #category : #accessing }
PBApplication >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
PBApplication >> start [
	self handlers do: #start.
	self waitInitialization.
	self postInitialization.
	self newCommandFactory send.
]

{ #category : #'start-stop' }
PBApplication >> stop [
	self handlers select: #notNil thenDo: #stop
]

{ #category : #private }
PBApplication >> waitInitialization [
	"Timeout of 10 seconds and try every 0.5 seconds"
	| error |

	1 to: 10 by: 0.5 do: [ :t |
		self isPythonReady 
				ifTrue: [ ^ self ]
				ifFalse: [ (Delay forMilliseconds: 500) wait ] ].
	"Store the error in a temporary variable since the debugger sometimes hides the parent stack frames."
	error := PBPythonProcessError new
		messageText: 'Python application initialization failed!';
		application: self.
	error signal.
	"
	Print the result of executing the following line:
	
	self errorMessage
	"
]

{ #category : #accessing }
PBApplication >> workingDirectory [ 

	^ settings workingDirectory ifNil: 
		[ FileLocator imageDirectory / self runtimeDirectory ]
]
