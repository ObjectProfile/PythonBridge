Class {
	#name : #PBBridgeBootstrap,
	#superclass : #Object,
	#instVars : [
		'bridgeName',
		'prefix',
		'packageName'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBBridgeBootstrap class >> createBridge: bridgeName prefix: prefix packageNamed: packageName [
	^ self new
		bridgeName: bridgeName;
		prefix: prefix;
		packageName: packageName;
		create
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

{ #category : #operations }
PBBridgeBootstrap >> create [
	self createApplication.
	self createCF.
	self createObject.
	self createTestCase.
	self createTestResource.
]

{ #category : #operations }
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

{ #category : #operations }
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

{ #category : #operations }
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

{ #category : #operations }
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

{ #category : #operations }
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
