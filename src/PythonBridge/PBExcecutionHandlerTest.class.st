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
	| dict |
	execHandler serializer: PBSerializer.
	commandFactory bindingAt: #foo put: #().
	dict := execHandler encodeCommandAsDictionary: commandFactory buildCommand.
	self assert: ((dict at: #bindings) at: #foo) equals: (execHandler serialize: #()).
	self deny: ((dict at: #bindings) at: #foo) = #()
]

{ #category : #accessing }
PBExcecutionHandlerTest >> testSerializeEncodeBindings [
	| dict |
	commandFactory bindingAt: #foo put: #().
	dict := execHandler encodeCommandAsDictionary: commandFactory buildCommand.
	self assert: ((dict at: #bindings) at: #foo) equals: (execHandler serialize: #()).
	self deny: ((dict at: #bindings) at: #foo) = #()
]
