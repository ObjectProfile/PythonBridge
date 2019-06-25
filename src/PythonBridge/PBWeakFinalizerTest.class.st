Class {
	#name : #PBWeakFinalizerTest,
	#superclass : #TestCase,
	#instVars : [
		'weakRegistry',
		'assertCounter'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #testing }
PBWeakFinalizerTest class >> isAbstract [
	^ self == PBWeakFinalizerTest
]

{ #category : #running }
PBWeakFinalizerTest >> assertCount: anInteger [
	self assert: assertCounter equals: anInteger
]

{ #category : #running }
PBWeakFinalizerTest >> countFinalizer [
	^ PBBlockFinalizer block: [ assertCounter := assertCounter + 1 ]
]

{ #category : #running }
PBWeakFinalizerTest >> setUp [
	super setUp.
	weakRegistry := self weakRegistryClass new.
	assertCounter := 0
]

{ #category : #running }
PBWeakFinalizerTest >> tearDown [
	weakRegistry destroy.
	super tearDown
]

{ #category : #running }
PBWeakFinalizerTest >> testBlockFinalizer [
	self assertCount: 0.
	self countFinalizer finalize.
	self assertCount: 1
]

{ #category : #running }
PBWeakFinalizerTest >> testGcMultObjects [
	| obj1 obj2 obj3 |
	obj1 := Object new.
	obj2 := Object new.
	obj3 := Object new.
	weakRegistry registerObject: obj1 finalizer: self countFinalizer.
	weakRegistry registerObject: obj2 finalizer: self countFinalizer.
	obj1 := nil.
	self triggerGC.
	self assertCount: 1.
	weakRegistry registerObject: obj3 finalizer: self countFinalizer.
	self triggerGC.
	self assertCount: 1.
	obj2 := nil.
	obj3 := nil.
	self triggerGC.
	self assertCount: 3
]

{ #category : #running }
PBWeakFinalizerTest >> testGcObject [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	obj := nil.
	self triggerGC.
	self assertCount: 1
]

{ #category : #running }
PBWeakFinalizerTest >> testNotGcObject [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	self assertCount: 0
]

{ #category : #running }
PBWeakFinalizerTest >> triggerGC [
	self subclassResponsibility
]

{ #category : #running }
PBWeakFinalizerTest >> weakRegistryClass [
	self subclassResponsibility
]
