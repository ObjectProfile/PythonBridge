Class {
	#name : #PBConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'oldApplication',
		'oldApp',
		'oldCF'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #running }
PBConnectionTest >> setUp [
	oldApp := PBApplication uniqueInstance.
	oldCF := PBCF current.
	PBCF current: nil.
	application := PBApplication new.
	PBApplication uniqueInstance: application
]

{ #category : #running }
PBConnectionTest >> tearDown [
	application stop.
	PBApplication uniqueInstance: oldApp.
	PBCF current: oldCF
]

{ #category : #tests }
PBConnectionTest >> testNotRunning [
	self deny: application isRunning
]

{ #category : #tests }
PBConnectionTest >> testSimpleExecution [
	self deny: application isRunning.
	application start.
	application send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))).	
	application stop.
	(Delay forMilliseconds: 150) wait.
	self should: [ application send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))) ] raise: Error.
]

{ #category : #tests }
PBConnectionTest >> testStartStopProcess [
	self deny: application isRunning.
	application start.
	self assert: application processHandler isRunning.
	application stop.
	(Delay forMilliseconds: 150) wait.
	self deny: application isRunning.
	self deny: application processHandler isRunning
]
