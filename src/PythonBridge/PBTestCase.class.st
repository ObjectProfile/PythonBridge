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
	^ self applicationClass uniqueInstance
]

{ #category : #initialization }
PBTestCase >> applicationClass [
	self subclassResponsibility 
]

{ #category : #asserting }
PBTestCase >> assertClass: cls name: aName [
	self cf << (cls => #__name__).
	self assert: self cf send waitForValue equals: aName
]

{ #category : #asserting }
PBTestCase >> assertExpression: expr equals: aBlockOrValue [
	self cf << expr.
	self assert: self cf send waitForValue equals: aBlockOrValue value
]

{ #category : #asserting }
PBTestCase >> assertInstanceClass: obj name: aName [
	self cf << ((#type asP3GI callWith: (Array with: obj)) => #__name__).
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
	^ self application commandFactory
]

{ #category : #asserting }
PBTestCase >> registryExpression [
	^ #registry callWith: #()
]

{ #category : #asserting }
PBTestCase >> resolveId: anId [
	^ self registryExpression => #resolve callWith: (Array with: anId)
]

{ #category : #running }
PBTestCase >> setUp [
	super setUp.
	self cf reset
]
