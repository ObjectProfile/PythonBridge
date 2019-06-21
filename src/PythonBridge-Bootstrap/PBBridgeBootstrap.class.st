Class {
	#name : #PBBridgeBootstrap,
	#superclass : #Object,
	#instVars : [
		'bridgeName',
		'prefix',
		'packageName'
	],
	#category : #'PythonBridge-Bootstrap'
}

{ #category : #'as yet unclassified' }
PBBridgeBootstrap class >> createBridge: bridgeName prefix: prefix packageNamed: packageName [
	^ self new
		bridgeName: bridgeName;
		prefix: prefix;
		packageName: packageName;
		create
]

{ #category : #accessing }
PBBridgeBootstrap >> applicationClass [
	^ Smalltalk at: self applicationName
]

{ #category : #names }
PBBridgeBootstrap >> applicationName [
	^ bridgeName asSymbol
]

{ #category : #accessing }
PBBridgeBootstrap >> bridgeName: anObject [
	bridgeName := anObject
]

{ #category : #names }
PBBridgeBootstrap >> commandFactoryName [
	^ prefix , 'CF'
]

{ #category : #create }
PBBridgeBootstrap >> create [
	self createClasses.
	self createRepository.
	self createFiles.
]

{ #category : #'create classes' }
PBBridgeBootstrap >> createApplication [
	| cls |
	cls := PBApplication subclass: self applicationName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls compile: 
'commandFactory
	^ ' , self commandFactoryName.
	cls compile:
'postInitialization
	"Insert here all statements related to the imports required by the bridge."
	'
]

{ #category : #'create classes' }
PBBridgeBootstrap >> createCF [
	| cls |
	cls := PBCF subclass: self commandFactoryName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls class compile: 
'applicationClass
	^ ' , self applicationName
]

{ #category : #create }
PBBridgeBootstrap >> createClasses [
	self createApplication.
	self createCF.
	self createObject.
	self createTestCase.
	self createTestResource.
]

{ #category : #create }
PBBridgeBootstrap >> createFiles [
	| folder |
	folder := self applicationClass repositoryFileReference.
	PBApplication repositoryFileReference / 'start_bridge.py' copyTo: folder / 'start_bridge.py'.
	PBApplication repositoryFileReference / 'Pipfile' copyTo: folder / 'Pipfile'.
	PBApplication repositoryFileReference / 'install_env.sh' copyTo: folder / 'install_env.sh'.
]

{ #category : #'create classes' }
PBBridgeBootstrap >> createObject [
	| cls |
	cls := PBObject subclass: self objectName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls compile: 
'applicationClass
	^ ' , self applicationName
]

{ #category : #create }
PBBridgeBootstrap >> createRepository [
	| repo |
	repo:= IceRepositoryCreator new 
				subdirectory: 'src';
				location: self packageName asFileReference;
				createNewRepositoryNamed: self packageName.
	repo register.
	repo workingCopy addPackageNamed: self packageName
]

{ #category : #'create classes' }
PBBridgeBootstrap >> createTestCase [
	| cls |
	cls := PBTestCase subclass: self testCaseName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls compile: 
'applicationClass
	^ ' , self applicationName.
	cls class compile: 
'appResource
	^ ' , self testResourceName
]

{ #category : #'create classes' }
PBBridgeBootstrap >> createTestResource [
	| cls |
	cls := PBApplicationTestResource subclass: self testResourceName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls compile: 
'applicationClass
	^ ' , self applicationName
]

{ #category : #names }
PBBridgeBootstrap >> objectName [
	^ prefix , 'Object'
]

{ #category : #names }
PBBridgeBootstrap >> packageName [
	^ packageName
]

{ #category : #accessing }
PBBridgeBootstrap >> packageName: anObject [
	packageName := anObject
]

{ #category : #accessing }
PBBridgeBootstrap >> prefix: anObject [
	prefix := anObject
]

{ #category : #names }
PBBridgeBootstrap >> testCaseName [
	^ prefix , 'TestCase'
]

{ #category : #names }
PBBridgeBootstrap >> testResourceName [
	^ prefix , 'TestResource'
]
