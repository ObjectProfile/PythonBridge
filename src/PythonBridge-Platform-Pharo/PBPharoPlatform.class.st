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
PBPharoPlatform class >> installEnvironmentForApp: application [
]

{ #category : #testing }
PBPharoPlatform class >> isAbstract [
	^ self name = 'PBPharoPlatform' asSymbol
]

{ #category : #hooks }
PBPharoPlatform class >> jsonSerializerClass [
	^ PBNeoJsonSerializer
]

{ #category : #hooks }
PBPharoPlatform class >> messageBrokerClass [
	^ PBPharoMessageBroker
]

{ #category : #hooks }
PBPharoPlatform class >> newRandomName [
	^ 'pb' , UUID new asString36
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
PBPharoPlatform class >> uiManagerClass [
	^ PBPharoUiManager
]

{ #category : #hooks }
PBPharoPlatform class >> weakRegistryClass [
	^ PBPharoWeakRegistry
]
