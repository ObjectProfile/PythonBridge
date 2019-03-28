Class {
	#name : #PBObjectFinalizationTest,
	#superclass : #PBApplicationTest,
	#instVars : [
		'debugMode'
	],
	#category : #'PythonBridge-Tests'
}

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
	| obj |
	obj := PBObject new basicCreateObjectExpr: 5.5.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	obj := nil.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assert: self cfSend waitForValue equals: nil.
]

{ #category : #tests }
PBObjectFinalizationTest >> testSimpleCreateObjectFromExpr [
	| obj |
	obj := PBObject new basicCreateObjectExpr: 5.5.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5
]
