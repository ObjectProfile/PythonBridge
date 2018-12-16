Class {
	#name : #PBCommandQueue,
	#superclass : #Object,
	#instVars : [
		'currentIndex',
		'innerCollection',
		'executionHandler'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBCommandQueue class >> executionHandler: aHandler [
	^ self new
			executionHandler: aHandler;
			yourself
]

{ #category : #accessing }
PBCommandQueue >> completedCommands [
	^ innerCollection first: currentIndex
]

{ #category : #accessing }
PBCommandQueue >> currentCommand [
	self isFinished ifTrue: [ ^ nil ].
	^ innerCollection at: currentIndex
]

{ #category : #accessing }
PBCommandQueue >> enqueueCommand: aCommand [
	innerCollection add: aCommand
]

{ #category : #accessing }
PBCommandQueue >> excecutionHandler [
	^ executionHandler
]

{ #category : #accessing }
PBCommandQueue >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
PBCommandQueue >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #accessing }
PBCommandQueue >> finishCommand: aCommand [
	^ self finishCommandId: aCommand id
]

{ #category : #accessing }
PBCommandQueue >> finishCommandId: id [
	| commandIndex |
	self currentCommand ifNotNil: [ :command |
		command id = id 
			ifTrue: [ 
				currentIndex := currentIndex + 1.
				^ true ] ].
	commandIndex := innerCollection detectIndex: [ :command | command id = id ].
	commandIndex > currentIndex 
		ifTrue: [ 
			currentIndex := commandIndex + 1.
			self log: (PBErrorLog message: 'Out of sync command queue. Pharo is delayed.') ]
		ifFalse: [ self log: (PBErrorLog message: 'Out of sync command queue. Python is delayed.') ].
	^ false
]

{ #category : #initialization }
PBCommandQueue >> initialize [
	super initialize.
	innerCollection := OrderedCollection new.
	currentIndex := 1
]

{ #category : #accessing }
PBCommandQueue >> isFinished [
	^ innerCollection size < currentIndex
]

{ #category : #accessing }
PBCommandQueue >> list [
	^ innerCollection
]

{ #category : #accessing }
PBCommandQueue >> nextCommand [
	| nextCommandIndex |
	nextCommandIndex := currentIndex + 1.
	innerCollection size < nextCommandIndex ifTrue: [ ^ nil ].
	^ innerCollection at: nextCommandIndex
]

{ #category : #accessing }
PBCommandQueue >> queue [
	^ self waitingCommands
]

{ #category : #accessing }
PBCommandQueue >> waitingCommands [
	^ innerCollection allButFirst: currentIndex
]
