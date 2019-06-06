Class {
	#name : #PBPharoPipenvProcess,
	#superclass : #PBAbstractProcess,
	#instVars : [
		'process',
		'settings',
		'workingDirectory',
		'environmentVariables',
		'pythonMainFile'
	],
	#classVars : [
		'PipenvPath'
	],
	#category : #'PythonBridge-Platform-Pharo'
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

{ #category : #accessing }
PBPharoPipenvProcess class >> settings: settings repositoryNamed: repoName [
	^ self new
		settings: settings;
		workingDirectory: (self workingDirectoryForRepositoryNamed: repoName);
		yourself
]

{ #category : #accessing }
PBPharoPipenvProcess class >> settings: settings workingDirectory: fileRef [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		yourself
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

{ #category : #initialization }
PBPharoPipenvProcess class >> workingDirectoryForRepositoryNamed: repoName [
	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: repoName ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location
]

{ #category : #accessing }
PBPharoPipenvProcess >> environmentVariables [
	^ environmentVariables
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
PBPharoPipenvProcess >> processArguments [
	^ { 
			'run'. 
			'python'. self pythonMainFile fullName. 
			'--port'. self settings pythonSocketAddress port asString . 
			'--pharo'. self settings pharoSocketAddress port asString }
]

{ #category : #accessing }
PBPharoPipenvProcess >> pythonMainFile [
	^ pythonMainFile ifNil: [ self workingDirectory / 'start_bridge.py' ]
]

{ #category : #accessing }
PBPharoPipenvProcess >> pythonMainFile: anObject [
	pythonMainFile := anObject
]

{ #category : #initialization }
PBPharoPipenvProcess >> setDefaultEnvironmentVariables [
	environmentVariables
		at: 'LC_ALL' put: 'en_US.UTF-8';
		at: 'LANG' put: 'en_US.UTF-8'
]

{ #category : #accessing }
PBPharoPipenvProcess >> settings [
	^ settings
]

{ #category : #accessing }
PBPharoPipenvProcess >> settings: anObject [
	settings := anObject
]

{ #category : #'as yet unclassified' }
PBPharoPipenvProcess >> start [
	process := self newProcess.
	process run
]

{ #category : #'as yet unclassified' }
PBPharoPipenvProcess >> stop [
	process ifNil: [ ^ self ].
	process isRunning ifTrue: [ process terminate ].
	process closeAndCleanStreams
]

{ #category : #accessing }
PBPharoPipenvProcess >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PBPharoPipenvProcess >> workingDirectory: anObject [
	workingDirectory := anObject
]

{ #category : #initialization }
PBPharoPipenvProcess >> workingDirectoryForRepositoryNamed: repoName [
	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: repoName ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location
]
