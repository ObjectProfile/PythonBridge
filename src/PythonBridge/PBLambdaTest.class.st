Class {
	#name : #PBLambdaTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-P3Generator'
}

{ #category : #tests }
PBLambdaTest >> assertCode: expr equals: targetStr [
	| string |
	string := String streamContents: [ :s | expr writePython3On: s ].
	self assert: string equals: targetStr
]

{ #category : #tests }
PBLambdaTest >> testMultipleArguments [
	| lambda |
	lambda := PBLambda 
					arguments: (Array with: #a asP3GI with: #b asP3GI with: #c asP3GI)
					expression: #a asP3GI + (#b asP3GI callWith: (Array with: #c asP3GI)).
	self assertCode: lambda equals: '(lambda a, b, c: a+b(c))'
]

{ #category : #tests }
PBLambdaTest >> testReturn1 [
	self assertCode: (PBLambda expression: 1) equals: '(lambda : 1)'
]

{ #category : #tests }
PBLambdaTest >> testSingleArgument [
	self assertCode: (PBLambda argument: #a asP3GI expression: #a asP3GI + 1) equals: '(lambda a: a+1)'
]
