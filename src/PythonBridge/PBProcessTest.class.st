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

{ #category : #running }
PBProcessTest >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6538)
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6539)
]

{ #category : #running }
PBProcessTest >> defaultTmpFile [
	self subclassResponsibility
]

{ #category : #hooks }
PBProcessTest >> processClass [
	self subclassResponsibility
]

{ #category : #running }
PBProcessTest >> setUp [

	super setUp.
	process := self processClass application: PBApplication new.
	process pythonMainFile: (process workingDirectory resolve resolve: self defaultTmpFile)
]

{ #category : #running }
PBProcessTest >> tearDown [
	process stop.
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
