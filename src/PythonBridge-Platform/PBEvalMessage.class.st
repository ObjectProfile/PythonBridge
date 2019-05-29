Class {
	#name : #PBEvalMessage,
	#superclass : #PBMessage,
	#instVars : [
		'commandId',
		'statements',
		'bindings'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBEvalMessage class >> commandId: commandId statements: statements bindings: bindings [
	^ self new
			commandId: commandId;
			statements: statements;
			bindings: bindings;
			yourself
]

{ #category : #accessing }
PBEvalMessage class >> type [
	^ 'EVAL'
]

{ #category : #accessing }
PBEvalMessage >> addBinding: assoc [
	bindings add: assoc
]

{ #category : #accessing }
PBEvalMessage >> addBindings: assocs [
	assocs do: [ :assoc | self addBinding: assoc ]
]

{ #category : #accessing }
PBEvalMessage >> bindings [
	^ bindings
]

{ #category : #accessing }
PBEvalMessage >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
PBEvalMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
PBEvalMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #initialization }
PBEvalMessage >> initialize [
	super initialize.
	bindings := Dictionary new
]

{ #category : #encoding }
PBEvalMessage >> privateEncode: dict [
	dict at: #commandId put: commandId.
	dict at: #statements put: statements.
	dict at: #bindings put: bindings
]

{ #category : #accessing }
PBEvalMessage >> statements [
	^ statements
]

{ #category : #accessing }
PBEvalMessage >> statements: anObject [
	statements := anObject
]
