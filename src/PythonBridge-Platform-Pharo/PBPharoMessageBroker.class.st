Class {
	#name : #PBPharoMessageBroker,
	#superclass : #PBAbstractMessageBroker,
	#instVars : [
		'server'
	],
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #private }
PBPharoMessageBroker >> handleRMessage: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	^ self handle: dict reverseMessageClass: msgClass
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
PBPharoMessageBroker >> primSendMessage: dict [
	| ans |
	ans := [ ZnEasy 
					post: self pythonUri , '/' , (dict at: #type)
					data: (ZnEntity text: (self serializer serialize: dict)) ] on: Error do: [ :err | PBCommunicationError signal: 'Request fail' ].
	ans status = 200 ifFalse: [ PBCommunicationError signal: 'Request fail' ].
	^ self serializer deserialize: ans contents
]

{ #category : #private }
PBPharoMessageBroker >> prim_handle: req [
	"Because of the nature of HTTP, answers of sync messages are not received through this method, but as 	the answers of HTTP requests. This channel is only for RMessages."
	req method = #POST 
		ifTrue: [ | dict ansDict handler |
			dict := self serializer deserialize: req contents.
			handler := [ self handleRMessage: dict ] 
							on: Error 
							do: [ :e | debugMode
												ifTrue: [ e pass ]
												ifFalse: [ ZnResponse serverError: e printString  ] ].
			ansDict := handler shouldAnswer
							ifTrue: [ handler answer encode ]
							ifFalse: [ Dictionary new ].
			^ ZnResponse ok: (ZnEntity json: (self serializer serialize: ansDict)) ]
		ifFalse: [ 
			^ self invalidMethod ]
]

{ #category : #messaging }
PBPharoMessageBroker >> sendAsyncMessage: msg [
	self primSendMessage: msg encode.
]

{ #category : #messaging }
PBPharoMessageBroker >> sendSyncMessage: msg [
	| ansDict |
	ansDict := self primSendMessage: msg encode.
	^ msg createAnswer decode: ansDict
]

{ #category : #accessing }
PBPharoMessageBroker >> serializer [
	^ PBPlatform current serializer
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
