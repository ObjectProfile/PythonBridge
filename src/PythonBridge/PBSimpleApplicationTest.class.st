Class {
	#name : #PBSimpleApplicationTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #accessing }
PBSimpleApplicationTest class >> resources [
	^ super resources , (Array with: PBApplicationTestResource)
]

{ #category : #tests }
PBSimpleApplicationTest >> setUp [
	super setUp.
	"self timeLimit: 5 seconds."
	PBCF reset
]

{ #category : #tests }
PBSimpleApplicationTest >> tearDown [
	super tearDown.
	PBCF reset
]

{ #category : #tests }
PBSimpleApplicationTest >> testSimpleRetrieveSameValue [
	| promise |
	PBCF << (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself).
	promise := PBApplication send: PBCF buildCommand.
	self assert: promise waitForValue equals: 3
]
