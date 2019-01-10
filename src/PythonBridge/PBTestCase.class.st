Class {
	#name : #PBTestCase,
	#superclass : #TestCase,
	#instVars : [
		'commandFactory',
		'promise'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #accessing }
PBTestCase class >> appResource [
	self subclassResponsibility
]

{ #category : #accessing }
PBTestCase class >> resources [
	^ super resources , (Array with: self appResource)
]

{ #category : #initialization }
PBTestCase >> app [
	^ self application
]

{ #category : #initialization }
PBTestCase >> application [
	^ self class appResource current application
]

{ #category : #initialization }
PBTestCase >> cf [
	^ self commandFactory
]

{ #category : #initialization }
PBTestCase >> cfSend [
	^ promise := self cf send
]

{ #category : #initialization }
PBTestCase >> commandFactory [
	^ commandFactory ifNil: [ commandFactory := self application newCommandFactory ]
]
