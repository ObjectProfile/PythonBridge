Class {
	#name : #PBPharoMessageBrokerTest,
	#superclass : #TestCase,
	#instVars : [
		'broker',
		'stubServer',
		'handlerBlock',
		'handlerException'
	],
	#category : #'PythonBridge-Pharo-Pipenv'
}

{ #category : #tests }
PBPharoMessageBrokerTest >> answer [
	^ ZnResponse ok: (ZnEntity text: 'OK')
]

{ #category : #acessing }
PBPharoMessageBrokerTest >> brokerPort [
	^ 6538
]

{ #category : #running }
PBPharoMessageBrokerTest >> buildAndStartStubServer [
	stubServer := ZnServer on: self portTest.
	stubServer start.
	stubServer onRequestRespond: [ :req | self primHandle: req ]
]

{ #category : #tests }
PBPharoMessageBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #initialization }
PBPharoMessageBrokerTest >> initialize [
	super initialize.
	handlerBlock := [ :r |  ]
]

{ #category : #acessing }
PBPharoMessageBrokerTest >> portTest [
	^ 6539
]

{ #category : #private }
PBPharoMessageBrokerTest >> primHandle: aRequest [
	| answer |
	answer := [
		handlerBlock value: 
			aRequest uri asString allButFirst 
				-> (NeoJSONReader fromString: aRequest contents)
		] on: Exception do: [ :e | 
			handlerException := e.
			self errorResponse ].
	(answer isKindOf: ZnResponse) ifFalse: [ answer := self errorResponse ].
	^ answer
]

{ #category : #acessing }
PBPharoMessageBrokerTest >> setHandler: aBlock [
	handlerBlock := aBlock
]

{ #category : #running }
PBPharoMessageBrokerTest >> setUp [
	super setUp.
	broker := PBPharoMessageBroker
		port: self brokerPort
		pythonUri: 'http://localhost:' , self portTest asString.
	broker start.
	self buildAndStartStubServer
]

{ #category : #running }
PBPharoMessageBrokerTest >> tearDown [
	broker ifNotNil: [ broker stop ].
	stubServer ifNotNil: [ stubServer stop ]
]

{ #category : #tests }
PBPharoMessageBrokerTest >> testEnqueueCommandMessage [
	| flag msg |
	flag := false.
	msg := PBEnqueueMessage 
				commandId: '7365'
				statements: 'foo().cat()'
				bindings: { #foo -> 42 . #bar -> 'zork' } asDictionary.
	self setHandler: [ :assoc | | bindings |
		self assert: assoc key equals: PBEnqueueMessage type.
		self assert: assoc value size equals: 4.
		self assert: (assoc value at: #type) equals: PBEnqueueMessage type.
		self assert: (assoc value at: #commandId) equals: '7365'.
		self assert: (assoc value at: #statements) equals: 'foo().cat()'.
		bindings := assoc value at: #bindings.
		self assert: bindings size equals: 2.
		self assert: (bindings at: #foo) equals: 42.
		self assert: (bindings at: #bar) equals: 'zork'.
		flag := true.
		self answer ].
	broker sendMessage: msg.
	self assert: flag
]

{ #category : #tests }
PBPharoMessageBrokerTest >> testIsAliveMessage [
	| flag |
	flag := false.
	self setHandler: [ :assoc |
		self assert: assoc key equals: PBIsAliveMessage type.
		self assert: assoc value associations size equals: 1.
		self assert: assoc value associations first key equals: #type.
		self assert: assoc value associations first value equals: PBIsAliveMessage type.
		flag := true.
		self answer ].
	broker sendMessage: PBIsAliveMessage new.
	self assert: flag
]

{ #category : #tests }
PBPharoMessageBrokerTest >> testIsRunning [
	self assert: broker isRunning
]
