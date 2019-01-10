Class {
	#name : #PBConnectionTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #running }
PBConnectionTest >> setUp [
	PBApplication stop
]

{ #category : #running }
PBConnectionTest >> tearDown [
	PBApplication resetUniqueInstance
]

{ #category : #tests }
PBConnectionTest >> testNotRunning [
	self deny: PBApplication isRunning
]

{ #category : #tests }
PBConnectionTest >> testStartStopProcess [
	| app |
	self deny: PBApplication isRunning.
	PBApplication start.
	app := PBApplication uniqueInstance.
	self assert: app processHandler isRunning.
	PBApplication send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))).	
	PBApplication stop.
	self deny: PBApplication isRunning.
	self should: [ app send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))) ] raise: Error.
	(Delay forMilliseconds: 100) wait.
	self deny: app processHandler isRunning
]
