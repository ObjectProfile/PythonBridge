Class {
	#name : #PBApplication,
	#superclass : #Object,
	#instVars : [
		'communicationHandler',
		'processHandler',
		'loggingHandler',
		'executionHandler'
	],
	#classVars : [
		'DebugMode'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'PythonBridge-Global'
}

{ #category : #'python hooks file' }
PBApplication class >> createSymlinkFolder [
	| symlinkRef |
	symlinkRef := self repositoryName asFileReference.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: self repositoryFileReference on: symlinkRef ]
]

{ #category : #'python hooks file' }
PBApplication class >> createSymlinkFor: originalFile on: targetFile [
	OSSUnixSubprocess new
				command: '/bin/ln';
				arguments: (Array 
									with: '-s' 
									with: originalFile asFileReference fullName 
									with: targetFile asFileReference fullName);
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command | ^ self ].
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
		retVal := aBlockClosure value.
		self uniqueInstance commandFactory << nil.
		self uniqueInstance commandFactory send waitForValue. ] ensure: [ self stop ].
	^ retVal
]

{ #category : #'python hooks file' }
PBApplication class >> ensurePythonBridgeSymlink [
	| symlinkRef |
	symlinkRef := (self repositoryFileReference / 'PythonBridge').
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: PBApplication repositoryFileReference on: symlinkRef ].
	
]

{ #category : #'pipenv setup' }
PBApplication class >> installPipenvEnvironment [
	| proc |
	self createSymlinkFolder.
	self ensurePythonBridgeSymlink.
	proc := OSSUnixSubprocess new
				command: '/bin/bash';
				arguments: (Array 
									with: (self repositoryFileReference / 'install_env.sh') fullName);
				terminateOnShutdown;
				runAndWait.
	proc exitStatus = 0 ifFalse: [ 
		self signalPipenvCreateEnvFailed ]
]

{ #category : #testing }
PBApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
]

{ #category : #'python hooks file' }
PBApplication class >> repositoryFileReference [
	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: self repositoryName ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location
]

{ #category : #'python hooks file' }
PBApplication class >> repositoryName [
	^ self package name
]

{ #category : #instructions }
PBApplication class >> resetUniqueInstance [
	uniqueInstance ifNotNil: [ 
		[ uniqueInstance stop ] 
			on: Error 
			do: [ UIManager inform: 'Error on reseting unique instance.' ]. ].
	uniqueInstance := nil
]

{ #category : #instructions }
PBApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
]

{ #category : #'pipenv setup' }
PBApplication class >> signalPipenvCreateEnvFailed [
	"
	Python bridge attempt of creating Pipenv environment failed. To attempt to generate the Pipenv
	environment manually go the project git folder. It may be the PythonBridge, KerasBridge or your
	Bridge, because each of them has a different Pipfile and Pipenv environment.
	
	To remove the current Pipenv environment run in the folder the command: `pipenv --rm`
	To manually create the Pipenv environment run in the folder the command: `bash install_env.sh`
	"
	Error signal: 'Attempt for creating Pipenv environment failed.'
]

{ #category : #'start-stop' }
PBApplication class >> start [
	self isRunning ifTrue: [ Error signal: 'Keras already running.' ].
	self stop.
	uniqueInstance := self new.
	uniqueInstance commandFactory reset.
	uniqueInstance start
]

{ #category : #'start-stop' }
PBApplication class >> stop [
	uniqueInstance ifNotNil: [ 
		uniqueInstance stop. ].
	uniqueInstance := nil
]

{ #category : #instructions }
PBApplication class >> uniqueInstance [
	^ uniqueInstance
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
	^ processHandler errorMessage
]

{ #category : #accessing }
PBApplication >> executionHandler [
	^ executionHandler
]

{ #category : #handlers }
PBApplication >> handlers [
	^ Array
		with: loggingHandler
		with: communicationHandler
		with: processHandler
		with: executionHandler
]

{ #category : #accessing }
PBApplication >> initialize [
	super initialize.
	self initializeHandlers.
]

{ #category : #initialization }
PBApplication >> initializeHandlers [
	loggingHandler := PBLoggingHandler application: self.
	communicationHandler := PBCommunicationHandler application: self.
	processHandler := PBPythonHandler application: self.
	executionHandler := PBExecutionHandler application: self
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

{ #category : #'instance creation' }
PBApplication >> newCommandFactory [
	^ self executionHandler newCommandFactory
]

{ #category : #accessing }
PBApplication >> postInitialization [
	
]

{ #category : #accessing }
PBApplication >> processHandler [
	^ processHandler
]

{ #category : #'as yet unclassified' }
PBApplication >> registerObject: aPythonObject [
	self executionHandler registerObject: aPythonObject
]

{ #category : #instructions }
PBApplication >> send: aCommand [
	^ executionHandler sendCommand: aCommand
]

{ #category : #accessing }
PBApplication >> start [
	self handlers do: #start.
	self waitInitialization.
	self postInitialization.
	self commandFactory send.
]

{ #category : #'as yet unclassified' }
PBApplication >> stop [
	self handlers select: #notNil thenDo: #stop
]

{ #category : #'as yet unclassified' }
PBApplication >> waitInitialization [
	"Timeout of 10 seconds and try every 0.5 seconds"
	1 to: 10 by: 0.5 do: [ :t |
		self isPythonReady 
				ifTrue: [ ^ self ]
				ifFalse: [ (Delay forMilliseconds: 500) wait ] ].
	Error signal: 'Python application initialization failed!'
	"
	Print the result of executing the following line:
	
	self errorMessage
	"
]
