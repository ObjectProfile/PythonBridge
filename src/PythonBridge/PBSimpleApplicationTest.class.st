Class {
	#name : #PBSimpleApplicationTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

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
