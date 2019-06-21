Class {
	#name : #PBProcessTest,
	#superclass : #TestCase,
	#instVars : [
		'process',
		'tmpPythonFile'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #testing }
PBProcessTest class >> isAbstract [
	^ self == PBProcessTest
]

{ #category : #utils }
PBProcessTest >> createTmpPythonFile [
	self subclassResponsibility
]

{ #category : #running }
PBProcessTest >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6538)
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6539)
]

{ #category : #utils }
PBProcessTest >> destroyTmpFile: aFile [
	self subclassResponsibility
]

{ #category : #hooks }
PBProcessTest >> processClass [
	self subclassResponsibility
]

{ #category : #running }
PBProcessTest >> setUp [
	super setUp.
	tmpPythonFile := self createTmpPythonFile.
	process := self processClass
		settings: self defaultSettings
		workingDirectory: self processClass workingDirectory.
	process pythonMainFile: tmpPythonFile
]

{ #category : #running }
PBProcessTest >> tearDown [
	process stop.
	self destroyTmpFile: tmpPythonFile.
	super tearDown
]

{ #category : #running }
PBProcessTest >> testStartStopProcess [
	self deny: process isRunning.
	process start.
	self assert: process isRunning.
	process stop.
	(Delay forMilliseconds: 150) wait.
	self deny: process isRunning
]
