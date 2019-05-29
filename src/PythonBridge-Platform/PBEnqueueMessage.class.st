Class {
	#name : #PBEnqueueMessage,
	#superclass : #PBMessage,
	#instVars : [
		'commandId',
		'statements',
		'bindings'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBEnqueueMessage class >> commandId: commandId statements: statements bindings: bindings [
	^ self new
			commandId: commandId;
			statements: statements;
			bindings: bindings;
			yourself
]

{ #category : #accessing }
PBEnqueueMessage class >> type [
	^ 'ENQUEUE'
]

{ #category : #accessing }
PBEnqueueMessage >> addBinding: assoc [
	bindings add: assoc
]

{ #category : #accessing }
PBEnqueueMessage >> addBindings: assocs [
	assocs do: [ :assoc | self addBinding: assoc ]
]

{ #category : #accessing }
PBEnqueueMessage >> bindings [
	^ bindings
]

{ #category : #accessing }
PBEnqueueMessage >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
PBEnqueueMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
PBEnqueueMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #initialization }
PBEnqueueMessage >> initialize [
	super initialize.
	bindings := Dictionary new
]

{ #category : #encoding }
PBEnqueueMessage >> privateEncode: dict [
	dict at: #commandId put: commandId.
	dict at: #statements put: statements.
	dict at: #bindings put: bindings
]

{ #category : #accessing }
PBEnqueueMessage >> statements [
	^ statements
]

{ #category : #accessing }
PBEnqueueMessage >> statements: anObject [
	statements := anObject
]
