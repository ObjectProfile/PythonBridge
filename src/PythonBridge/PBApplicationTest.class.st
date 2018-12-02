Class {
	#name : #PBApplicationTest,
	#superclass : #TestCase,
	#category : #PythonBridge
}

{ #category : #running }
PBApplicationTest >> tearDown [
	PBApplication isRunning ifTrue: [ PBApplication stop ]
]

{ #category : #tests }
PBApplicationTest >> testNotRunning [
	self deny: PBApplication isRunning
]

{ #category : #tests }
PBApplicationTest >> testStart [
	self deny: PBApplication isRunning.
	PBApplication start.
	self assert: PBApplication isRunning.
]

{ #category : #tests }
PBApplicationTest >> testStop [
	self deny: PBApplication isRunning.
	PBApplication start.
	PBApplication stop.
	self deny: PBApplication isRunning.
]
