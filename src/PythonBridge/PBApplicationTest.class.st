Class {
	#name : #PBApplicationTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #running }
PBApplicationTest >> tearDown [
	PBApplication resetUniqueInstance
]

{ #category : #tests }
PBApplicationTest >> testNotRunning [
	self deny: PBApplication isRunning
]

{ #category : #tests }
PBApplicationTest >> testRejectSimpleCommand [
	| app |
	PBApplication start.
	app := PBApplication uniqueInstance.
	PBApplication stop.
	self should: [ app send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))) ] raise: Error
]

{ #category : #tests }
PBApplicationTest >> testSendSimpleCommand [
	PBApplication start.
	PBApplication send: 
		(PBCommand new instructions: 
			(Array with: (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))).
]

{ #category : #tests }
PBApplicationTest >> testStart [
	self deny: PBApplication isRunning.
	PBApplication start.
	self assert: PBApplication isRunning.
]

{ #category : #tests }
PBApplicationTest >> testStopProcess [
	| processHandler |
	self deny: PBApplication isRunning.
	PBApplication start.
	processHandler := PBApplication uniqueInstance processHandler.
	self assert: processHandler isRunning.
	PBApplication stop.
	self deny: PBApplication isRunning.
	(Delay forMilliseconds: 100) wait.
	self deny: processHandler isRunning
]
