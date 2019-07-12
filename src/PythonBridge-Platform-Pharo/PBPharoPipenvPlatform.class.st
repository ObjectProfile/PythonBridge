Class {
	#name : #PBPharoPipenvPlatform,
	#superclass : #PBPharoPlatform,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #'as yet unclassified' }
PBPharoPipenvPlatform class >> ensureEnvironmentForApp: anApplication [
	self ensureApplicationSymlinks: anApplication.
	self installEnvironmentForApp: anApplication.
]

{ #category : #utils }
PBPharoPipenvPlatform class >> forceInstallEnvironmentForApp: application [
	| proc |
	self assert: PBPharoPipenvProcess pipenvPath isEmptyOrNil not.
	proc := OSSUnixSubprocess new
				command: '/bin/bash';
				addAllEnvVariablesFromParentWithoutOverride;
				arguments: (Array 
					with: ((self folderForApplication: application) / 'install_env.sh') fullName);
				terminateOnShutdown;
				runAndWait.
	(proc exitStatus = 0 or: [ proc exitStatus < -1000 ]) ifFalse: [ 
		self signalPipenvCreateEnvFailed ]
]

{ #category : #hooks }
PBPharoPipenvPlatform class >> installEnvironmentForApp: application [
	| folder |
	folder := self folderForApplication: application.
	(folder / '.venv') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #accessing }
PBPharoPipenvPlatform class >> priority [
	^ 10
]

{ #category : #hooks }
PBPharoPipenvPlatform class >> processClass [
	^ PBPharoPipenvProcess
]

{ #category : #private }
PBPharoPipenvPlatform class >> signalPipenvCreateEnvFailed [
	"
	Python bridge attempt of creating Pipenv environment failed. To attempt to generate the Pipenv
	environment manually go the project git folder. It may be the PythonBridge, KerasBridge or your
	Bridge, because each of them has a different Pipfile and Pipenv environment.
	
	To remove the current Pipenv environment run in the folder the command: `pipenv --rm`
	To manually create the Pipenv environment run in the folder the command: `bash install_env.sh`
	"
	Error signal: 'Attempt for creating Pipenv environment failed.'
]
