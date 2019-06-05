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
PBPharoMessageBroker >> addCallback: aBlock answerClass: answerCls [
	messageCallbacks at: answerCls put: aBlock
]

{ #category : #messaging }
PBPharoMessageBroker >> decode: request [
	^ NeoJSONReader fromString: request contents
]

{ #category : #messaging }
PBPharoMessageBroker >> encodeAnswer: aMessage [
	^ aMessage encode
]

{ #category : #private }
PBPharoMessageBroker >> handleMessage: aDict [
	| msgClass answerMsg |
	msgClass := self resolveMessageFromType: (aDict at: #type).
	(messageCallbacks includesKey: msgClass) 
		ifFalse: [ ^ self invalidType ].
	answerMsg := (messageCallbacks at: msgClass) value: aDict.
	(answerMsg isKindOf: PBAnswer) ifFalse: [ PBCommunicationError signal ].
	^ answerMsg
]

{ #category : #initialization }
PBPharoMessageBroker >> initialize [
	super initialize.
	messageCallbacks := Dictionary new.
	debugMode := false
]

{ #category : #private }
PBPharoMessageBroker >> invalidMethod [
	^ (ZnResponse statusLine: ZnStatusLine badRequest)
		entity: (ZnEntity text: 'Bad method');
		yourself
]

{ #category : #private }
PBPharoMessageBroker >> invalidType [
	^ (ZnResponse statusLine: ZnStatusLine notFound)
		entity: (ZnEntity text: 'Invalid type');
		yourself
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
		ifTrue: [ | dict ans |
			dict := self decode: req.
			ans := [ self handleMessage: dict ] 
							on: Error 
							do: [ :e | debugMode
												ifTrue: [ e pass ]
												ifFalse: [ ZnResponse serverError: e printString  ] ].
			^ ZnResponse ok: (ZnEntity json: (self encodeAnswer: ans)) ]
		ifFalse: [ 
			^ self invalidMethod ]
]

{ #category : #accessing }
PBPharoMessageBroker >> pythonUri [
	^ pythonUri
]

{ #category : #accessing }
PBPharoMessageBroker >> pythonUri: anObject [
	pythonUri := anObject
]

{ #category : #private }
PBPharoMessageBroker >> resolveMessageFromType: aType [
	^ PBAnswer resolveMessageClassFromType: aType
]

{ #category : #messaging }
PBPharoMessageBroker >> sendMessage: aMessage [
	| ans |
	ans := ZnEasy 
				post: self pythonUri , '/' , aMessage type
				data: (ZnEntity text: aMessage encode).
	ans status = 200 ifFalse: [ PBCommunicationError signal: 'Request fail' ]
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
