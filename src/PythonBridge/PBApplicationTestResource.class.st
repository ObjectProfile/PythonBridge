Class {
	#name : #PBApplicationTestResource,
	#superclass : #TestResource,
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBApplicationTestResource >> application [
	^ PBApplication
]

{ #category : #initialization }
PBApplicationTestResource >> setUp [
	super initialize.
	self application stop.
	self application start
]

{ #category : #initialization }
PBApplicationTestResource >> tearDown [
	super tearDown.
	self application stop
]
