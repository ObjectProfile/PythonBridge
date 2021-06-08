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
	<return: #FileReference>

	^ RuntimeSourceDirectory
]

{ #category : #accessing }
PBPharoPlatform class >> runtimeSourceDirectory: aFileReference [
	"Set the directory the contains the runtime files.
	nil = not specified"

	RuntimeSourceDirectory := aFileReference asFileReference
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
	| srcDir cpCommand proc srcFilename dstFilename |

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
	proc := OSSUnixSubprocess new 
		shellCommand: cpCommand;
		runAndWait.
	proc isSuccess ifFalse:
		[ self error: 'Unable to install PythonBridge runtime' ].

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

]

{ #category : #private }
PBPharoPlatform >> ensureEnvironmentForApp: anApplication [

	self ensureApplicationDirectory: anApplication.
	self installEnvironmentForApp: anApplication.
]

{ #category : #utils }
PBPharoPlatform >> forceInstallEnvironmentForApp: application [
	| proc pipenvPath |

	pipenvPath := self pipenvForApplication: application.
	self assert: pipenvPath exists description: 'pipenv is apparently not accessible at a standard location. Please, have a look at the Troubleshooting section of https://objectprofile.github.io/PythonBridge/pages/pharo-installation'.
	proc := OSSUnixSubprocess new
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
	proc isSuccess ifFalse: [ self signalPipenvCreateEnvFailed ].
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

{ #category : #accessing }
PBPharoPlatform >> pipenvForApplication: application [
	"Answer the pipenv path for the supplied application"

	^ application settings pipenvPath ifNil:
		[ self class pipenvProcessClass pipenvPath ]
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
PBPharoPlatform >> signalPipenvCreateEnvFailed [
	"
	Python bridge attempt of creating Pipenv environment failed. To attempt to generate the Pipenv
	environment manually go the project git folder. It may be the PythonBridge, KerasBridge or your
	Bridge, because each of them has a different Pipfile and Pipenv environment.
	
	To remove the current Pipenv environment run in the folder the command: `pipenv --rm`
	To manually create the Pipenv environment run in the folder the command: `bash install_env.sh`
	"
	Error signal: 'Attempt for creating Pipenv environment failed.'
]
