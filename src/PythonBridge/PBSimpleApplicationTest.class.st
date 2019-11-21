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
PBSimpleApplicationTest >> testSimpleLambda [
	self cf << ((P3GLambda 
						argument: #a asP3GI
						expression: #a asP3GI + 1) callWith: #( 2 )).
	self assert: self cf send waitForValue equals: 3
]

{ #category : #tests }
PBSimpleApplicationTest >> testSimpleMapping [
	| obj type |
	obj := self cf sendAndWait: #bridge_globals asP3GI => #msg_service.
	type := self cf sendAndWait: (#type asP3GI callWith: (Array with: obj)).
	self application addMapping: type to: (P3GLambda 
														argument: #x asP3GI 
														expression: 'STRING!!').
	self assert: (self cf sendAndWait: obj) equals: 'STRING!!'
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
