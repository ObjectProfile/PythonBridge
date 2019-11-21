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
PBObjectFinalizationTest >> testCreateObjectAndGcItBeforeSending [
	"Bug when the object is garbage collected before sending the command to python, this trigger the gc in Python of an object that hasnt yer been created nor registered. Now we fixed this enforcing the message send in the basicCreateObject, though another way is to registering the object to the command with a hard-reference."
	PBObject new basicCreateObjectExpr: 5.5.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assert: true
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
