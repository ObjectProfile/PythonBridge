Class {
	#name : #PBObjectFinalizationTest,
	#superclass : #PBApplicationTest,
	#instVars : [
		'debugMode'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #asserting }
PBObjectFinalizationTest >> idInRegistry: anId [
	^ self registryExpression => #hasId callWith: (Array with: anId)
]

{ #category : #asserting }
PBObjectFinalizationTest >> registryExpression [
	^ #registry callWith: #()
]

{ #category : #asserting }
PBObjectFinalizationTest >> resolveId: anId [
	^ self registryExpression => #resolve callWith: (Array with: anId)
]

{ #category : #initialization }
PBObjectFinalizationTest >> setUp [
	super setUp.
	debugMode := PBApplication debugMode.
	PBApplication debugMode: false.
]

{ #category : #initialization }
PBObjectFinalizationTest >> tearDown [
	PBApplication debugMode: debugMode.
	super tearDown
]

{ #category : #tests }
PBObjectFinalizationTest >> testGCSimpleObj [
	| obj id |
	obj := PBObject new basicCreateObjectExpr: 5.5.
	id := obj id.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	self assertExpression: (self idInRegistry: id) equals: true.
	obj := nil.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assertExpression: (self idInRegistry: id) equals: false.
]

{ #category : #tests }
PBObjectFinalizationTest >> testSimpleCreateObjectFromExpr [
	| obj |
	obj := PBObject new basicCreateObjectExpr: 5.5.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	self assertExpression: (self resolveId: obj id) equals: 5.5
]
