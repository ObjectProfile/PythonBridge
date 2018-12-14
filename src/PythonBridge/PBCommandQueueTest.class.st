Class {
	#name : #PBCommandQueueTest,
	#superclass : #TestCase,
	#instVars : [
		'queue'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBCommandQueueTest >> setUp [
	queue := PBCommandQueue new
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
