Class {
	#name : #PBExecutionHandler,
	#superclass : #PBHandler,
	#instVars : [
		'commandQueue',
		'serializer',
		'promiseRegistry'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #'private protocol' }
PBExecutionHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
PBExecutionHandler >> deserialize: anObject [
	^ self serializer deserialize: anObject
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
		at: #bindings put: (p3Bindings collect: [ :obj | self serialize: obj ]).
	^ data
]

{ #category : #initialization }
PBExecutionHandler >> initialize [
	super initialize.
	commandQueue := PBCommandQueue new.
	serializer := PBSerializer.
	promiseRegistry := PBPromiseRegistry new
]

{ #category : #initialization }
PBExecutionHandler >> initializeHandler [
	self communicationHandler
		addRoute: '/notify' block: [ :dict | self notifyHandler: dict ];
		addRoute: '/notifyError' block: [ :dict | self notifyErrorHandler: dict ]
]

{ #category : #initialization }
PBExecutionHandler >> notifyErrorHandler: dict [
	| error |
	error := PBPythonError new
					application: self application;
					command: (commandQueue getCommand: (dict at: #id));
					errorMessage: (dict at: #errMsg);
					yourself.
	self safeTriggerDebugger: error.
	^ ZnResponse ok: (ZnEntity text: (NeoJSONWriter toString: error proceedAction encodedAsDictionary))
]

{ #category : #initialization }
PBExecutionHandler >> notifyHandler: dict [
	^ dict
		at: #id
		ifPresent:
			[ :id | self updatePromiseId: id with: (self deserialize: (dict at: #value)) ]
		ifAbsent: [ self application
				log: (PBErrorLog message: 'Notify for missing promise.') ]
]

{ #category : #'private protocol' }
PBExecutionHandler >> primitiveSendCommand: command [
	self communicationHandler 
		sendPath: '/eval'
		data: (NeoJSONWriter toString: (self encodeCommandAsDictionary: command)).
]

{ #category : #'private protocol' }
PBExecutionHandler >> registerPromiseForCommand: aCommand [
	| promise |
	promise := PBPromise new
					id: aCommand id;
					transformBlock: aCommand transformBlock;
					yourself.
	aCommand promise: promise.
	promiseRegistry addPromise: promise.
	^ promise
]

{ #category : #'as yet unclassified' }
PBExecutionHandler >> safeTriggerDebugger: error [
	[ self triggerDebugger: error ] 
		ifCurtailed: [ 
			error proceedAction: error defaultProceedAction ]
]

{ #category : #'private protocol' }
PBExecutionHandler >> sendCommand: command [
	| promise |
	self assert: command isValid.
	commandQueue enqueueCommand: command.
	promise := self registerPromiseForCommand: command.
	self primitiveSendCommand: command.
	^ promise
]

{ #category : #'private protocol' }
PBExecutionHandler >> serialize: anObject [
	^ self serializer serialize: anObject
]

{ #category : #accessing }
PBExecutionHandler >> serializer [
	^ serializer
]

{ #category : #accessing }
PBExecutionHandler >> serializer: anObject [
	serializer := anObject
]

{ #category : #'as yet unclassified' }
PBExecutionHandler >> triggerDebugger: pythonError [
	"This method is called when an error rised on Python execution."
	"Inspect error to review the Command that caused the error.
	For ignoring error:
		pythonError proceedAction: PBIgnore new
	For aborting:
		pythonError proceedAction: PBDropQueue new
	For replacing the command that caused the error:
		pythonError proceedAction: P3ReplaceCommandAction new newCommand: **Your crafted command**
	To execute your action you just need to 'Proceed' in the debugger."
	pythonError signal.
]

{ #category : #'private protocol' }
PBExecutionHandler >> updatePromiseId: id with: anObject [
	commandQueue finishCommandId: id.
	promiseRegistry removeAndSignalPromiseId: id with: anObject
]
