Class {
	#name : #PBPharoPlatform,
	#superclass : #PBPlatform,
	#classVars : [
		'RuntimeSourceDirectory'
	],
	#category : #'PythonBridge-Pharo-Platform'
}

{ #category : #hooks }
PBPharoPlatform class >> httpMessageBrokerClass [
	^ PBHttpMessageBroker
]

{ #category : #hooks }
PBPharoPlatform class >> pipenvProcessClass [
	^ PBPharoPipenvProcess
]

{ #category : #accessing }
PBPharoPlatform class >> priority [
	^ 10
]

{ #category : #accessing }
PBPharoPlatform class >> runtimeSourceDirectory [
	<return: #AbstractFileReference>

	^ RuntimeSourceDirectory
]

{ #category : #accessing }
PBPharoPlatform class >> runtimeSourceDirectory: anAbstractFileReference [
	"Set the directory the contains the runtime files.
	nil = not specified"

	RuntimeSourceDirectory := anAbstractFileReference
]

{ #category : #hooks }
PBPharoPlatform class >> socketMessageBrokerClass [
	^ PBMsgPackPharoBroker
]

{ #category : #private }
PBPharoPlatform class >> uiManagerClass [
	^ PBPharoUiManager
]

{ #category : #hooks }
PBPharoPlatform class >> weakRegistryClass [
	^ PBPharoWeakRegistry
]

{ #category : #private }
PBPharoPlatform >> copyApplicationTo: appFolder application: application [
	"Copy the PythonBridge runtime environment to the specified folder"
	| srcDir cpCommand proc srcFilename dstFilename error |

	srcDir := self runtimeSourceDirectoryFor: application.
	srcDir resolve = appFolder resolve ifTrue: [ ^ self ].

	"Copy the runtime directory"
	srcFilename := srcDir resolve fullName copyReplaceAll: '"' with: '\"'.
	dstFilename := appFolder resolve fullName copyReplaceAll: '"' with: '\"'.
	cpCommand := String streamContents: [ :stream |
		stream
			<< 'cp -a "';
			<< srcFilename;
			<< '" "';
			<< dstFilename;
			<< '"' ].
	proc := PBUnixSubprocess new 
		shellCommand: cpCommand;
		runAndWait.
	proc isSuccess ifFalse:
		[ error := PBPythonProcessError new
			messageText: 'Unable to install PythonBridge runtime';
			application: application;
			process: proc.
		error signal ].

]

{ #category : #'message broker strategy' }
PBPharoPlatform >> defaultMessageBrokerClass [
	^ self class socketMessageBrokerClass
]

{ #category : #hooks }
PBPharoPlatform >> ensureApplicationDirectory: application [
	| appFolder |

	appFolder := application workingDirectory.
	(appFolder / 'PythonBridge') exists ifTrue: [ ^ self ].
	self copyApplicationTo: appFolder application: application.
	self setExecutableIn: appFolder application: application.


]

{ #category : #private }
PBPharoPlatform >> ensureEnvironmentForApp: anApplication [

	[ self ensureApplicationDirectory: anApplication.
	self installEnvironmentForApp: anApplication ] asJob
		title: 'Installing PythonBridge runtime environment';
		run
]

{ #category : #utils }
PBPharoPlatform >> forceInstallEnvironmentForApp: application [
	| proc pipenvPath |

	pipenvPath := application pipenvPath.
	self assert: pipenvPath exists description: 'pipenv is apparently not accessible at a standard location. Please, have a look at the Troubleshooting section of https://objectprofile.github.io/PythonBridge/pages/pharo-installation'.
	proc := PBUnixSubprocess new
				command: '/bin/bash';
				workingDirectory: application workingDirectory fullName;
				addAllEnvVariablesFromParentWithoutOverride.
	proc
		environmentAt: 'PATH'
		put: pipenvPath parent fullName,
				':', (proc envVariables at: 'PATH').
	proc
		arguments: (Array 
			with: (application workingDirectory / 'install_env.sh') fullName);
		terminateOnShutdown;
		runAndWait.
	proc isSuccess ifFalse: [ self signalPipenvCreateEnvFailed: application process: proc ].
]

{ #category : #utils }
PBPharoPlatform >> installEnvironmentForApp: application [
	| folder |
	folder := application workingDirectory.
	(folder / '.venv') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #hooks }
PBPharoPlatform >> newRandomName [
	^ 'pb' , UUID new asString36
]

{ #category : #utils }
PBPharoPlatform >> runtimeSourceDirectoryFor: aPBApplication [
	"Answer the source directory containing the runtime files.
	This is the first of:
	1. RuntimeSourceDirectory (if specified)
	2. The git repository copy.
	3. An existing copy in the image directory"
	| fileReference |

	(RuntimeSourceDirectory isNotNil and: [ RuntimeSourceDirectory exists ]) ifTrue: 
		[ ^ RuntimeSourceDirectory ].
	IceRepository registry 
			detect: [ :each | each includesPackageNamed: aPBApplication class package name ] 
			ifFound: [ :repository | 
					fileReference := repository location / 'PythonBridgeRuntime'.
					fileReference exists ifTrue: [ ^ fileReference ] ]
			ifNone: [ ].
	fileReference := FileLocator imageDirectory / 'PythonBridgeRuntime'.
	fileReference exists ifTrue: [ ^ fileReference ].
	self error: 'Unable to locate PythonBridge runtime source'.
]

{ #category : #private }
PBPharoPlatform >> setExecutableIn: appFolder application: application [
	"Copy the PythonBridge runtime environment to the specified folder"
	| chmodCommand proc error appFolderString |

	appFolderString := appFolder resolve fullName copyReplaceAll: '"' with: '\"'.
	chmodCommand := String streamContents: [ :stream |
		stream
			<< 'chmod +x "';
			<< appFolderString;
			<< '"/*.sh' ].
	proc := OSSUnixSubprocess new 
		shellCommand: chmodCommand;
		runAndWait.
	proc isSuccess ifFalse:
		[ error := PBPythonProcessError new
			messageText: 'Unable to set PythonBridge runtime executable bits';
			application: application;
			process: proc.
		error signal ].

]

{ #category : #private }
PBPharoPlatform >> signalPipenvCreateEnvFailed: application process: proc [
	"The attempt to install the python environment failed.
	Signal the error.

	To manually track down the issue, go to the working directory as shown in the signal and:
	
	To remove the current Pipenv environment run in the folder the command: `pipenv --rm`
	To manually create the Pipenv environment run in the folder the command: `bash install_env.sh`"
	| error |

	"Save the error in a temporary variable for access while debugging since the debugger hides the signal stack entries"
	error := PBPythonProcessError new
		application: application;
		process: proc.
	error signal
]
