Class {
	#name : #PBObjectFinalizationTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBObjectFinalizationTest >> testSimpleCreateObjectFromExpr [
	| obj |
	obj := PBObject new basicCreateObjectExpr: 3.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 3
]
