Class {
	#name : #PBLambda,
	#superclass : #P3GGenerable,
	#traits : 'P3GCallable + P3GBinaryOperationSupport',
	#classTraits : 'P3GCallable classTrait + P3GBinaryOperationSupport classTrait',
	#instVars : [
		'arguments',
		'expression'
	],
	#category : #'PythonBridge-P3Generator'
}

{ #category : #'as yet unclassified' }
PBLambda class >> argument: anIdentifier expression: aPythonExpression [
	^ self arguments: (Array with: anIdentifier) expression: aPythonExpression
]

{ #category : #'as yet unclassified' }
PBLambda class >> arguments: listOfP3GI expression: aPythonExpression [
	^ self new
		arguments: listOfP3GI;
		expression: aPythonExpression;
		yourself
]

{ #category : #'as yet unclassified' }
PBLambda class >> expression: aPythonExpression [
	^ self arguments: #() expression: aPythonExpression
]

{ #category : #accessing }
PBLambda >> arguments [
	^ arguments
]

{ #category : #accessing }
PBLambda >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
PBLambda >> expression [
	^ expression
]

{ #category : #accessing }
PBLambda >> expression: anObject [
	expression := anObject
]

{ #category : #accessing }
PBLambda >> writePython3On: aStream [
	aStream << '(lambda '.
	arguments 
		do: [ :arg | arg writePython3On: aStream ]
		separatedBy: [ aStream << ', ' ].
	aStream << ': '.
	expression writePython3On: aStream.
	aStream << ')'.
]
