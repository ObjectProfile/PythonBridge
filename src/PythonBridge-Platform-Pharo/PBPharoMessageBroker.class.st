Class {
	#name : #PBPharoMessageBroker,
	#superclass : #PBAbstractMessageBroker,
	#instVars : [
		'server'
	],
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #messaging }
PBPharoMessageBroker >> decode: request [
	^ NeoJSONReader fromString: request contents
]

{ #category : #messaging }
PBPharoMessageBroker >> encode: aMessage [
	^ NeoJSONWriter toString: aMessage encode
]

{ #category : #private }
PBPharoMessageBroker >> handleMessage: aDict [
	| msgClass answerMsg |
	msgClass := self resolveMessageFromType: (aDict at: #type).
	(messageCallbacks includesKey: msgClass) 
		ifFalse: [ ^ self invalidType ].
	answerMsg := (messageCallbacks at: msgClass) value: aDict.
	(answerMsg isKindOf: PBOldAnswer) ifFalse: [ PBCommunicationError signal ].
	^ answerMsg
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
			^ ZnResponse ok: (ZnEntity json: (self encode: ans)) ]
		ifFalse: [ 
			^ self invalidMethod ]
]

{ #category : #messaging }
PBPharoMessageBroker >> sendAsyncMessage: aMessage [
	self sendSyncMessage: aMessage
]

{ #category : #messaging }
PBPharoMessageBroker >> sendMessage: aMessage [
	| ans |
	ans := [ ZnEasy 
					post: self pythonUri , '/' , aMessage type
					data: (ZnEntity text: (self encode: aMessage)) ] on: Error do: [ :err | PBCommunicationError signal: 'Request fail' ].
	ans status = 200 ifFalse: [ PBCommunicationError signal: 'Request fail' ].
	^ ans contents
]

{ #category : #messaging }
PBPharoMessageBroker >> sendSyncMessage: aMessage [
	| ans |
	ans := [ ZnEasy 
					post: self pythonUri , '/' , aMessage type
					data: (ZnEntity text: (self encode: aMessage)) ] on: Error do: [ :err | PBCommunicationError signal: 'Request fail' ].
	ans status = 200 ifFalse: [ PBCommunicationError signal: 'Request fail' ].
	^ ans contents
]

{ #category : #accessing }
PBPharoMessageBroker >> setDebugMode [
	super setDebugMode.
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
