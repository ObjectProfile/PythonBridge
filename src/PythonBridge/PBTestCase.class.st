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

{ #category : #asserting }
PBTestCase >> assertClass: cls name: aName [
	self cf << (cls => #__name__).
	self assert: self cf send waitForValue equals: aName
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
