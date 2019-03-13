Class {
	#name : #PBRegistryFinalizer,
	#superclass : #Object,
	#instVars : [
		'pythonVariable',
		'executionHandler'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #accessing }
PBRegistryFinalizer class >> pythonVariable: aPythonVariable executionHandler: executionHandler [
	^ self new
		pythonVariable: aPythonVariable;
		executionHandler: executionHandler
		yourself
]

{ #category : #accessing }
PBRegistryFinalizer >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
PBRegistryFinalizer >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #finalization }
PBRegistryFinalizer >> finalize [
	| cf |
	executionHandler isRunning ifFalse: [ ^ self ].
	cf := executionHandler newCommandFactory.
	cf << (pythonVariable <- nil).
	cf send.
]

{ #category : #accessing }
PBRegistryFinalizer >> pythonVariable [
	^ pythonVariable
]

{ #category : #accessing }
PBRegistryFinalizer >> pythonVariable: anObject [
	pythonVariable := anObject
]
