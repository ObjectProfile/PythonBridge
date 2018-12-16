Class {
	#name : #PBExecutionHandler,
	#superclass : #PBHandler,
	#instVars : [
		'commandQueue',
		'currentCommandIndex'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'private protocol' }
PBExecutionHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
PBExecutionHandler >> encodeCommandAsDictionary: aCommand [
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
PBExecutionHandler >> initialize [
	super initialize.
	commandQueue := OrderedCollection new.
	currentCommandIndex := 1
]

{ #category : #initialization }
PBExecutionHandler >> initializeHandler [
	self communicationHandler 
		addRoute: '/notify' 
		block: [ :dict | 
			dict 
				at: #id 
				ifPresent: [ :id |
					self updatePromiseId: id with: (self deserialize: (dict at: #value)) ]
				ifAbsent: [ 
					self application log: (PBErrorLog message: 'Notify for missing promise.') ] ]
]

{ #category : #'private protocol' }
PBExecutionHandler >> primitiveSendCommand: command [
	self communicationHandler 
		sendPath: '/eval'
		data: (NeoJSONWriter toString: (self encodeCommandAsDictionary: command)).
]

{ #category : #'private protocol' }
PBExecutionHandler >> sendCommand: command [
	self assert: command isValid.
	commandQueue add: command.
	^ self primitiveSendCommand: command
]
