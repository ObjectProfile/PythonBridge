Class {
	#name : #PBPharoPlatform,
	#superclass : #PBPlatform,
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

{ #category : #'private - symlinks' }
PBPharoPlatform >> createSymlinkFor: originalFile on: targetFile [
	OSSUnixSubprocess new
				command: '/bin/ln';
				arguments: (Array 
									with: '-s' 
									with: originalFile asFileReference fullName 
									with: targetFile asFileReference fullName);
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command | ^ self ].
]

{ #category : #'message broker strategy' }
PBPharoPlatform >> defaultMessageBrokerClass [
	^ self class socketMessageBrokerClass
]

{ #category : #hooks }
PBPharoPlatform >> ensureApplicationSymlinks: application [
	| appFolder |

	appFolder := self runtimeFolderForApplication: application.
	appFolder exists ifFalse:
		[ self ensureFolderSymlinkFor: appFolder.
		self ensurePBridge: (self folderForApplication: application class baseApplication) symlinkIn: appFolder ]
]

{ #category : #private }
PBPharoPlatform >> ensureEnvironmentForApp: anApplication [
	self ensureApplicationSymlinks: anApplication.
	self installEnvironmentForApp: anApplication.
]

{ #category : #'private - symlinks' }
PBPharoPlatform >> ensureFolderSymlinkFor: aFolder [
	| symlinkRef |
	symlinkRef := aFolder basename asFileReference.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: aFolder on: symlinkRef ]
]

{ #category : #'private - symlinks' }
PBPharoPlatform >> ensurePBridge: pbridgeFolder symlinkIn: aFolder [
	| symlinkRef |
	symlinkRef := aFolder / 'PythonBridge'.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: pbridgeFolder on: symlinkRef ].
]

{ #category : #utils }
PBPharoPlatform >> folderForApplication: application [
	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: application class package name ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location
]

{ #category : #utils }
PBPharoPlatform >> forceInstallEnvironmentForApp: application [
	| proc |
	self assert: PBPharoPipenvProcess pipenvPath isEmptyOrNil not description: 'pipenv is apparently not accessible at a standard location. Please, have a look at the Troubleshooting section of https://objectprofile.github.io/PythonBridge/pages/pharo-installation'.
	proc := OSSUnixSubprocess new
				command: '/bin/bash';
				addAllEnvVariablesFromParentWithoutOverride;
				arguments: (Array 
					with: ((self runtimeFolderForApplication: application) / 'install_env.sh') fullName);
				terminateOnShutdown;
				runAndWait.
	(proc exitStatus = 0 or: [ proc exitStatus < -1000 or: [ proc exitStatus > SmallInteger maxVal ] ]) ifFalse: [ 
		self signalPipenvCreateEnvFailed ]
]

{ #category : #utils }
PBPharoPlatform >> installEnvironmentForApp: application [
	| folder |
	folder := self runtimeFolderForApplication: application.
	(folder / '.venv') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #hooks }
PBPharoPlatform >> newRandomName [
	^ 'pb' , UUID new asString36
]

{ #category : #accessing }
PBPharoPlatform >> runtimeFolder [
	"Answer the directory where the PythonBridge runtime files are located"

	^ FileLocator imageDirectory / 'PythonBridge'
]

{ #category : #accessing }
PBPharoPlatform >> runtimeFolderForApplication: application [
	"Answer the directory where the PythonBridge runtime files are located"

	^ FileLocator imageDirectory / application runtimeDirectory
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
