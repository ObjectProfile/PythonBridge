Class {
	#name : #PBCommandHandler,
	#superclass : #PBHandler,
	#instVars : [
		'commandList'
	],
	#category : #PythonBridge
}

{ #category : #'private protocol' }
PBCommandHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
PBCommandHandler >> encodeCommandAsDictionary: aCommand [
	| py3CodeStream p3Bindings data |
	py3CodeStream := String new writeStream.
	aCommand pythonGenerable writePython3On: py3CodeStream.
	p3Bindings := aCommand bindings asDictionary.
	p3Bindings at: #pharoCommandId put: aCommand id.
	data := Dictionary new.
	data 
		at: #commandId put: aCommand id;
		at: #statements put: py3CodeStream contents;
		at: #bindings put: p3Bindings.
	^ data
]

{ #category : #'private protocol' }
PBCommandHandler >> sendCommand: command [
	self assert: command isValid.
	self communicationHandler 
		sendPath: '/eval'
		data: (NeoJSONWriter toString: (self encodeCommandAsDictionary: command)).
]
