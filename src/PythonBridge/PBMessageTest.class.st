Class {
	#name : #PBMessageTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #tests }
PBMessageTest >> stubMessage [
	^ PBStubMessage new
		ivar1: #foo;
		ivar2: #(3 #bar);
		yourself
]

{ #category : #tests }
PBMessageTest >> testDecodeAnswer [
	| msg dict ans |
	msg := self stubMessage.
	dict := {
		(#type -> #STUB).
		(#ivar1 -> #foo).
		(#ivar2f -> 3).
		(#ivar2r -> #(#zork)).
		(#__sync -> msg syncId)} asDictionary.
	ans := msg createAnswer decode: dict.
	self assert: ans ivar1 equals: #foo.
	self assert: ans ivar2 equals: #(3 #zork).
]

{ #category : #tests }
PBMessageTest >> testDecodeBaseMessage [
	self 
		assert: (PBSyncMessage new createAnswer decode: { #type -> #MSG } asDictionary) class
		equals: PBAnswer
]

{ #category : #tests }
PBMessageTest >> testEncodeBaseMessage [
	self 
		assert: PBMessage new encode 
		equals: { #type -> #MSG } asDictionary
]

{ #category : #tests }
PBMessageTest >> testEncodeMessage [
	| msg dict |
	msg := self stubMessage.
	dict := {
		(#type -> #STUB).
		(#ivar1 -> #foo).
		(#ivar2f -> 3).
		(#ivar2r -> #(#bar)).
		(#__sync -> msg syncId)} asDictionary.
	self assert: msg encode equals: dict
]

{ #category : #tests }
PBMessageTest >> testNoDuplicatedTypes [
	| messageClasses |
	messageClasses := PBAbstractMessage allSubclasses.
	self assert: (messageClasses collect: #type) asSet size equals: messageClasses size
]
