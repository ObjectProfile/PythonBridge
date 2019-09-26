Class {
	#name : #PBEnqueueMessageOld,
	#superclass : #PBOldMessage,
	#instVars : [
		'commandId',
		'statements',
		'bindings'
	],
	#category : #'PythonBridge-Platform-Messages-Old'
}

{ #category : #'as yet unclassified' }
PBEnqueueMessageOld class >> commandId: commandId statements: statements bindings: bindings [
	^ self new
			commandId: commandId;
			statements: statements;
			bindings: bindings;
			yourself
]

{ #category : #accessing }
PBEnqueueMessageOld class >> type [
	^ 'ENQUEUE'
]

{ #category : #accessing }
PBEnqueueMessageOld >> addBinding: assoc [
	bindings add: assoc
]

{ #category : #accessing }
PBEnqueueMessageOld >> addBindings: assocs [
	assocs do: [ :assoc | self addBinding: assoc ]
]

{ #category : #accessing }
PBEnqueueMessageOld >> bindings [
	^ bindings
]

{ #category : #accessing }
PBEnqueueMessageOld >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
PBEnqueueMessageOld >> commandId [
	^ commandId
]

{ #category : #accessing }
PBEnqueueMessageOld >> commandId: anObject [
	commandId := anObject
]

{ #category : #initialization }
PBEnqueueMessageOld >> initialize [
	super initialize.
	bindings := Dictionary new
]

{ #category : #encoding }
PBEnqueueMessageOld >> privateEncode: dict [
	dict at: #commandId put: commandId.
	dict at: #statements put: statements.
	dict at: #bindings put: bindings
]

{ #category : #accessing }
PBEnqueueMessageOld >> statements [
	^ statements
]

{ #category : #accessing }
PBEnqueueMessageOld >> statements: anObject [
	statements := anObject
]
