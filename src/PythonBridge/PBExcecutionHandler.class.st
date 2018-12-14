Class {
	#name : #PBExcecutionHandler,
	#superclass : #PBHandler,
	#instVars : [
		'commandQueue'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'private protocol' }
PBExcecutionHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
PBExcecutionHandler >> encodeCommandAsDictionary: aCommand [
	| p3Bindings data |
	p3Bindings := aCommand bindings asDictionary.
	p3Bindings at: #pharoCommandId put: aCommand id.
	data := Dictionary new.
	data 
		at: #commandId put: aCommand id;
		at: #statements put: aCommand pythonCode;
		at: #bindings put: p3Bindings.
	^ data
]

{ #category : #initialization }
PBExcecutionHandler >> initialize [
	super initialize.
	commandQueue := OrderedCollection new
]

{ #category : #'private protocol' }
PBExcecutionHandler >> primitiveSendCommand: command [
	self communicationHandler 
		sendPath: '/eval'
		data: (NeoJSONWriter toString: (self encodeCommandAsDictionary: command)).
]

{ #category : #'private protocol' }
PBExcecutionHandler >> sendCommand: command [
	self assert: command isValid.
	commandQueue add: command.
	^ self primitiveSendCommand: command
]
