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

{ #category : #testing }
PBApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
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

	^ 'PythonBridge'
]

{ #category : #instructions }
PBApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
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
PBApplication >> postInitialization [
	
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
	1 to: 10 by: 0.5 do: [ :t |
		self isPythonReady 
				ifTrue: [ ^ self ]
				ifFalse: [ (Delay forMilliseconds: 500) wait ] ].
	Error signal: 'Python application initialization failed! You should try to manually install the Pipenv environment. Have a look at the section "Manually creating Pipenv environment" in https://objectprofile.github.io/PythonBridge/pages/pharo-installation'.
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
