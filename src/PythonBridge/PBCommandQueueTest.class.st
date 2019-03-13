Class {
	#name : #PBCommandQueueTest,
	#superclass : #TestCase,
	#instVars : [
		'queue',
		'app'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBCommandQueueTest >> setUp [
	| execHandler |
	app := PBStubApplication new.
	execHandler := PBExecutionHandler basicNew 
							application: app;
							yourself.
	queue := PBCommandQueue executionHandler: execHandler
]

{ #category : #tests }
PBCommandQueueTest >> testCleaningCommand [
	| cc1 cc2 |
	cc1 := PBCommand new.
	cc2 := PBCommand new.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self assert: (queue finishCommand: cc1).
	self assert: queue list size equals: 1.
	self assert: (queue finishCommand: cc2).
	self assert: queue isFinished
]

{ #category : #tests }
PBCommandQueueTest >> testEmptyQueue [
	self assert: queue list isEmpty.
	self assert: queue isFinished.
	self assert: queue currentCommand isNil
]

{ #category : #tests }
PBCommandQueueTest >> testEnqueue [
	| c |
	c := PBCommand new.
	queue enqueueCommand: c.
	self assert: queue list size equals: 1.
	self assert: queue currentCommand equals: c.
	
]

{ #category : #tests }
PBCommandQueueTest >> testFinishCommand [
	| cc |
	cc := PBCommand new.
	queue enqueueCommand: cc.
	self assert: (queue finishCommand: cc).
	self assert: queue isFinished
]

{ #category : #tests }
PBCommandQueueTest >> testFinishCommand2 [
	| cc |
	cc := PBCommand new.
	queue enqueueCommand: cc.
	queue enqueueCommand: PBCommand new.
	self assert: (queue finishCommand: cc).
	self deny: queue isFinished
]

{ #category : #tests }
PBCommandQueueTest >> testFinishNotFoundCommand [
	self 
		should: [ queue finishCommandId: 'aa' ]
		raise: NotFound
]

{ #category : #tests }
PBCommandQueueTest >> testFinishOutOfSync1Command [
	| cc1 cc2 |
	cc1 := PBCommand new.
	cc2 := PBCommand new.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self deny: (queue finishCommand: cc2).
	self assert: queue isFinished
]

{ #category : #tests }
PBCommandQueueTest >> testFinishOutOfSync2Command [
	| cc1 cc2 |
	cc1 := PBCommand new.
	cc2 := PBCommand new.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self deny: (queue finishCommand: cc2).
	self deny: (queue finishCommand: cc1).
	self assert: queue isFinished
]

{ #category : #tests }
PBCommandQueueTest >> testNotFoundCommand [
	queue enqueueCommand: PBCommand new.
	self 
		should: [ queue finishCommandId: 'aa' ]
		raise: NotFound
]
