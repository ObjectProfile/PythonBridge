Class {
	#name : #PBPharoPlatform,
	#superclass : #PBPlatform,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #'private - symlinks' }
PBPharoPlatform class >> createSymlinkFor: originalFile on: targetFile [
	OSSUnixSubprocess new
				command: '/bin/ln';
				arguments: (Array 
									with: '-s' 
									with: originalFile asFileReference fullName 
									with: targetFile asFileReference fullName);
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command | ^ self ].
]

{ #category : #hooks }
PBPharoPlatform class >> ensureApplicationSymlinks: application [
	| appFolder |
	appFolder := self folderForApplication: application.
	self ensureFolderSymlinkFor: appFolder.
	self ensurePBridge: (self folderForApplication: application class baseApplication) symlinkIn: appFolder
]

{ #category : #'private - symlinks' }
PBPharoPlatform class >> ensureFolderSymlinkFor: aFolder [
	| symlinkRef |
	symlinkRef := aFolder basename asFileReference.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: aFolder on: symlinkRef ]
]

{ #category : #'private - symlinks' }
PBPharoPlatform class >> ensurePBridge: pbridgeFolder symlinkIn: aFolder [
	| symlinkRef |
	symlinkRef := aFolder / 'PythonBridge'.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: pbridgeFolder on: symlinkRef ].
]

{ #category : #utils }
PBPharoPlatform class >> folderForApplication: application [
	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: application class package name ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location
]

{ #category : #utils }
PBPharoPlatform class >> forceInstallEnvironmentForApp: application [
	| proc |
	self assert: PBPharoPipenvProcess pipenvPath isEmptyOrNil not.
	proc := OSSUnixSubprocess new
				command: '/bin/bash';
				addAllEnvVariablesFromParentWithoutOverride;
				arguments: (Array 
					with: ((self folderForApplication: application) / 'install_env.sh') fullName);
				terminateOnShutdown;
				redirectStderr;
				redirectStdout;
				runAndWait.
	(proc exitStatus = 0 or: [ proc exitStatus = -6917529027641081856 ]) ifFalse: [ 
		self signalPipenvCreateEnvFailed ]
]

{ #category : #hooks }
PBPharoPlatform class >> installEnvironmentForApp: application [
	| folder |
	folder := self folderForApplication: application.
	(folder / '.venv') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #hooks }
PBPharoPlatform class >> messageBrokerClass [
	^ PBPharoMessageBroker
]

{ #category : #accessing }
PBPharoPlatform class >> priority [
	^ 1
]

{ #category : #hooks }
PBPharoPlatform class >> processClass [
	self subclassResponsibility
]

{ #category : #private }
PBPharoPlatform class >> signalPipenvCreateEnvFailed [
	"
	Python bridge attempt of creating Pipenv environment failed. To attempt to generate the Pipenv
	environment manually go the project git folder. It may be the PythonBridge, KerasBridge or your
	Bridge, because each of them has a different Pipfile and Pipenv environment.
	
	To remove the current Pipenv environment run in the folder the command: `pipenv --rm`
	To manually create the Pipenv environment run in the folder the command: `bash install_env.sh`
	"
	Error signal: 'Attempt for creating Pipenv environment failed.'
]
