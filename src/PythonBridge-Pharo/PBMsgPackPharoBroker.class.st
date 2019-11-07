Class {
	#name : #PBMsgPackPharoBroker,
	#superclass : #PBAbstractMessageBroker,
	#instVars : [
		'serverSocket',
		'handlerThread',
		'msgStream',
		'syncRegistry'
	],
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #accessing }
PBMsgPackPharoBroker class >> pythonMethodArg [
	^ 'msgpack'
]

{ #category : #accessing }
PBMsgPackPharoBroker class >> serializerClass [
	^ PBMsgPackSerializer
]

{ #category : #private }
PBMsgPackPharoBroker >> _primHandle: dict [
	^ [ self primHandle: dict ] ifCurtailed: [ ^ self ]
]

{ #category : #private }
PBMsgPackPharoBroker >> handleAnswerMessage: dict [
	| assoc message semaphore |
	assoc := syncRegistry at: (dict at: #__sync).
	message := assoc key.
	semaphore := assoc value.
	syncRegistry at: message syncId put: (message createAnswer decode: dict).
	semaphore signal
]

{ #category : #initialization }
PBMsgPackPharoBroker >> initialize [
	super initialize.
	syncRegistry := Dictionary new
]

{ #category : #testing }
PBMsgPackPharoBroker >> isRunning [
	^ msgStream notNil and: [ msgStream isConnected ]
]

{ #category : #private }
PBMsgPackPharoBroker >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: handlerThread 
			ifAbsent: [  ] ]
]

{ #category : #private }
PBMsgPackPharoBroker >> primHandle: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	msgClass isReverseMessage
		ifTrue: [ | handler |
			handler := self handle: dict reverseMessageClass: msgClass.
			handler shouldAnswer ifTrue: [ self primSendMessage: handler answer encode ] ]
		ifFalse: [ 
			self handleAnswerMessage: dict ]
]

{ #category : #private }
PBMsgPackPharoBroker >> primSendMessage: dict [
	msgStream ifNil: [ PBCommunicationError signal ].
	msgStream nextPut: dict
]

{ #category : #private }
PBMsgPackPharoBroker >> registerSemaphoreForMessage: message [
	| semaphore |
	semaphore := Semaphore new.
	syncRegistry at: message syncId put: message -> semaphore.
	^ semaphore
]

{ #category : #private }
PBMsgPackPharoBroker >> retrieveAnswerForSyncId: syncId [
	| msgAnswer |
	msgAnswer := syncRegistry at: syncId.
	syncRegistry removeKey: syncId.
	^ msgAnswer
]

{ #category : #messaging }
PBMsgPackPharoBroker >> sendAsyncMessage: msg [
	self primSendMessage: msg encode.
]

{ #category : #messaging }
PBMsgPackPharoBroker >> sendSyncMessage: msg [
	| syncSemaphore ansDict |
	syncSemaphore := self registerSemaphoreForMessage: msg. 
	self primSendMessage: msg encode.
	syncSemaphore wait.
	ansDict := self retrieveAnswerForSyncId: msg syncId.
	^ msg createAnswer decode: ansDict
]

{ #category : #'private - utils' }
PBMsgPackPharoBroker >> serverSocketOn: port [
	| socket |
	(socket := Socket newTCP)
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: PBMsgPackUtils socketBufferSize;
		setOption: 'SO_RCVBUF' value: PBMsgPackUtils socketBufferSize .
	socket listenOn: port backlogSize: PBMsgPackUtils listenBacklogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : #'start-stop' }
PBMsgPackPharoBroker >> start [
	serverSocket := self serverSocketOn: self port.
	handlerThread := [	| bindSocket |	
		bindSocket := serverSocket waitForAcceptFor: 10.
		bindSocket ifNil: [ bindSocket := serverSocket waitForAcceptFor: 10 ].
		bindSocket ifNotNil: [ 
			msgStream := PBMsgPackSocketStream on: (SocketStream on: bindSocket).
			[ [ true ] whileTrue: [ 
				self _primHandle: msgStream next ] ] 
					on: ConnectionClosed 
					do: [ :err | "Do nothing." ] ] ] forkAt: Processor lowIOPriority.
	self preventTestForkedPDestroyServer
]

{ #category : #'start-stop' }
PBMsgPackPharoBroker >> stop [
	handlerThread ifNotNil: [ handlerThread terminate ].
	msgStream ifNotNil: [ msgStream close ].
	serverSocket ifNotNil: [ serverSocket closeAndDestroy ]
]
