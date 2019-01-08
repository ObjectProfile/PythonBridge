Class {
	#name : #PBSimpleApplicationTest,
	#superclass : #TestCase,
	#instVars : [
		'commandFactory'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #accessing }
PBSimpleApplicationTest class >> resources [
	^ super resources , (Array with: PBApplicationTestResource)
]

{ #category : #initialization }
PBSimpleApplicationTest >> app [
	^ self application
]

{ #category : #initialization }
PBSimpleApplicationTest >> application [
	^ PBApplicationTestResource current application
]

{ #category : #initialization }
PBSimpleApplicationTest >> cf [
	^ self commandFactory
]

{ #category : #initialization }
PBSimpleApplicationTest >> commandFactory [
	^ commandFactory ifNil: [ commandFactory := self application newCommandFactory ]
]

{ #category : #tests }
PBSimpleApplicationTest >> testDoubleRetrieveValue [
	| promise |
	self cf << (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 3.
	self cf << (P3GBinaryOperator new
						left: 3;
						right: 4;
						operator: $*;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 12
]

{ #category : #tests }
PBSimpleApplicationTest >> testSimpleRetrieveSameValue [
	| promise |
	self cf << (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 3
]

{ #category : #tests }
PBSimpleApplicationTest >> testSimpleRetrieveSameValue2 [
	| promise |
	self cf << (P3GBinaryOperator new
						left: 3;
						right: 4;
						operator: $*;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 12
]
