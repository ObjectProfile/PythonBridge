Class {
	#name : #PBConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #running }
PBConnectionTest >> tearDown [
	PBApplication isRunning ifTrue: [ PBApplication stop ]
]

{ #category : #tests }
PBConnectionTest >> testNotRunning [
	self deny: PBApplication isRunning
]

{ #category : #tests }
PBConnectionTest >> testStartStopProcess [
	self deny: PBApplication isRunning.
	PBApplication start.
	self assert: PBApplication uniqueInstance processHandler isRunning.
	PBApplication send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))).	
	PBApplication stop.
	(Delay forMilliseconds: 150) wait.
	self deny: PBApplication isRunning.
	self should: [ PBApplication send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))) ] raise: Error.
]
