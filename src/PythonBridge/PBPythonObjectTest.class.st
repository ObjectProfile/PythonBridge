Class {
	#name : #PBPythonObjectTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBPythonObjectTest >> testSimpleProxy [
	| obj |
	self cf << self registryExpression.
	obj := self cfSend waitForValue.
	self assert: obj class equals: PBProxyObject.
	self assertInstanceClass: obj name: 'Registry'.
	self assertExpression: (obj => #hasId callWith: #(0)) equals: false
]
