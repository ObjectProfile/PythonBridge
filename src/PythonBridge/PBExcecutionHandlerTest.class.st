Class {
	#name : #PBExcecutionHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'execHandler'
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
]

{ #category : #accessing }
PBExcecutionHandlerTest >> testJSONSerializeEncodeBindings [
	| dict |
	execHandler serializer: PBSerializer.
	PBCF bindingAt: #foo put: #().
	dict := execHandler encodeCommandAsDictionary: PBCF buildCommand.
	self assert: ((dict at: #bindings) at: #foo) equals: (execHandler serialize: #()).
	self deny: ((dict at: #bindings) at: #foo) = #()
]

{ #category : #accessing }
PBExcecutionHandlerTest >> testSerializeEncodeBindings [
	| dict |
	PBCF bindingAt: #foo put: #().
	dict := execHandler encodeCommandAsDictionary: PBCF buildCommand.
	self assert: ((dict at: #bindings) at: #foo) equals: (execHandler serialize: #()).
	self deny: ((dict at: #bindings) at: #foo) = #()
]
