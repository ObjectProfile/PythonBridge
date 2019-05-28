Class {
	#name : #PBPharoMessageBroker,
	#superclass : #PBAbstractMessageBroker,
	#instVars : [
		'messageCallbacks',
		'port',
		'pythonUri',
		'server',
		'debugMode'
	],
	#category : #'PythonBridge-Pharo-Pipenv'
}

{ #category : #'as yet unclassified' }
PBPharoMessageBroker class >> port: port pythonUri: pythonUri [
	^ self new
		port: port;
		pythonUri: pythonUri
]

{ #category : #messaging }
PBPharoMessageBroker >> addCallback: aCallback messageClass: msgCls [
	messageCallbacks at: msgCls put: aCallback
]

{ #category : #testing }
PBPharoMessageBroker >> isRunning [
	^ server notNil
]

{ #category : #accessing }
PBPharoMessageBroker >> port [
	^ port
]

{ #category : #accessing }
PBPharoMessageBroker >> port: anObject [
	port := anObject
]

{ #category : #private }
PBPharoMessageBroker >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: server process 
			ifAbsent: [  ] ]
]

{ #category : #private }
PBPharoMessageBroker >> prim_handle: req [
	req method = #POST 
		ifTrue: [ | message |
			message := self decodeMessage: req.
			^ self handleMessage: message ]
		ifFalse: [ 
			^ self invalidMessageResponse ]
]

{ #category : #accessing }
PBPharoMessageBroker >> pythonUri [
	^ pythonUri
]

{ #category : #accessing }
PBPharoMessageBroker >> pythonUri: anObject [
	pythonUri := anObject
]

{ #category : #messaging }
PBPharoMessageBroker >> sendMessage: aMessage [
	| ans |
	ans := ZnEasy 
				post: 'http://localhost:' , self pythonPort asString , '/' , aMessage type;
				data: (ZnEntity text: aMessage encodeBody).
	ans status = 200 ifFalse: [ Error signal: 'Command rejected by python' ]
]

{ #category : #accessing }
PBPharoMessageBroker >> setDebugMode [
	debugMode := true.
	server ifNotNil: [ server debugMode: true ]
]

{ #category : #'start-stop' }
PBPharoMessageBroker >> start [
	server := ZnServer on: self port.
	server debugMode: debugMode.
	server start.
	self preventTestForkedPDestroyServer.
	self
		assert: server isRunning & server isListening
		description:
			('Failed to start server on port {1}. Is there one already?' format: {server port}).
	server onRequestRespond: [ :req | self prim_handle: req ]
]

{ #category : #'start-stop' }
PBPharoMessageBroker >> stop [
	server ifNotNil: [ server stop ]
]
