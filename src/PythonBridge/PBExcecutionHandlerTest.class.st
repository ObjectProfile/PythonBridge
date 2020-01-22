Class {
	#name : #PBExcecutionHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'execHandler',
		'commandFactory'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBExcecutionHandlerTest >> setUp [
	| app |
	app := PBStubApplication new.
	execHandler := PBExecutionHandler new 
							application: app;
							yourself.
	commandFactory := PBCommandFactory new.
]

{ #category : #accessing }
PBExcecutionHandlerTest >> testJSONSerializeEncodeBindings [
	| message |
	commandFactory bindingAt: #foo put: #().
	message := execHandler buildMessageFromCommand: commandFactory buildCommand.
	self assert: (message bindings at: #foo) equals: (execHandler serialize: #()).
	self deny: (message bindings at: #foo) = #()
]

{ #category : #accessing }
PBExcecutionHandlerTest >> testSerializeEncodeBindings [
	| message |
	commandFactory bindingAt: #foo put: #().
	message := execHandler buildMessageFromCommand: commandFactory buildCommand.
	self assert: (message bindings at: #foo) equals: (execHandler serialize: #()).
	self deny: (message bindings at: #foo) = #()
]
