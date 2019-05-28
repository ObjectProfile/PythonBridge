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
PBPharoMessageBrokerTest >> answer: ans [
	^ ZnResponse ok: (ZnEntity json: ans encode)
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
PBPharoMessageBrokerTest >> testIsAliveMessage [
	| flag answer |
	flag := false.
	self setHandler: [ :assoc |
		self assert: assoc key equals: PBIsAliveMessage type.
		self assert: assoc value associations size equals: 1.
		self assert: assoc value associations first key equals: #type.
		self assert: assoc value associations first value equals: PBIsAliveMessage type.
		flag := true.
		self answer: PBIsAliveAnswer new ].
	answer := broker sendMessage: PBIsAliveMessage new.
	self assert: answer type equals: PBIsAliveMessage type.
	self assert: flag
]

{ #category : #tests }
PBPharoMessageBrokerTest >> testIsRunning [
	self assert: broker isRunning
]
