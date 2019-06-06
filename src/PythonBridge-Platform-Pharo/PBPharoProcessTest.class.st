Class {
	#name : #PBPharoProcessTest,
	#superclass : #TestCase,
	#instVars : [
		'process',
		'tmpPythonFile'
	],
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #running }
PBPharoProcessTest >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6538)
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6539)
]

{ #category : #running }
PBPharoProcessTest >> setUp [
	super setUp.
	tmpPythonFile := FileLocator workingDirectory / 'tmp.py'.
	tmpPythonFile writeStream close.
	process := PBPharoPipenvProcess 
						settings: self defaultSettings 
						workingDirectory: FileLocator workingDirectory.
	process pythonMainFile: tmpPythonFile.
]

{ #category : #running }
PBPharoProcessTest >> tearDown [
	| rawProcess |
	rawProcess := process process.
	tmpPythonFile deleteIfAbsent: [  ].
	rawProcess ifNotNil: [ 
			rawProcess isRunning ifTrue: [ rawProcess terminate].
			process process closeAndCleanStreams ].
	super tearDown
]

{ #category : #running }
PBPharoProcessTest >> testStartStopProcess [
	self deny: process isRunning.
	process start.
	self assert: process isRunning.
	process stop.
	(Delay forMilliseconds: 150) wait.
	self deny: process isRunning
]
