Class {
	#name : #PBEnqueueCommandMessage,
	#superclass : #PBAsyncMessage,
	#instVars : [
		'commandId',
		'statements',
		'bindings'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #'as yet unclassified' }
PBEnqueueCommandMessage class >> commandId: commandId statements: statements bindings: bindings [
	^ self new
			commandId: commandId;
			statements: statements;
			bindings: bindings;
			yourself
]

{ #category : #'as yet unclassified' }
PBEnqueueCommandMessage class >> type [
	^ 'ENQUEUE'
]

{ #category : #adding }
PBEnqueueCommandMessage >> addBinding: assoc [
	bindings add: assoc
]

{ #category : #adding }
PBEnqueueCommandMessage >> addBindings: assocs [
	assocs do: [ :assoc | self addBinding: assoc ]
]

{ #category : #accessing }
PBEnqueueCommandMessage >> bindings [
	^ bindings
]

{ #category : #accessing }
PBEnqueueCommandMessage >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
PBEnqueueCommandMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
PBEnqueueCommandMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #adding }
PBEnqueueCommandMessage >> initialize [
	super initialize.
	bindings := Dictionary new
]

{ #category : #adding }
PBEnqueueCommandMessage >> privateEncode: dict [
	dict at: #commandId put: commandId.
	dict at: #statements put: statements.
	dict at: #bindings put: bindings
]

{ #category : #accessing }
PBEnqueueCommandMessage >> statements [
	^ statements
]

{ #category : #accessing }
PBEnqueueCommandMessage >> statements: anObject [
	statements := anObject
]
