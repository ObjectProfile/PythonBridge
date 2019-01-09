Class {
	#name : #PBApplicationTestResource,
	#superclass : #TestResource,
	#instVars : [
		'application'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBApplicationTestResource >> app [
	^ self application
]

{ #category : #initialization }
PBApplicationTestResource >> application [
	^ application
]

{ #category : #initialization }
PBApplicationTestResource >> applicationClass [
	^ PBApplication
]

{ #category : #initialization }
PBApplicationTestResource >> setUp [
	super setUp.
	application := self applicationClass new.
	self application start
]

{ #category : #initialization }
PBApplicationTestResource >> tearDown [
	self application stop.
	super tearDown.
]
