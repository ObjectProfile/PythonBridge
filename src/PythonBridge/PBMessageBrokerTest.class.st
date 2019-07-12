Class {
	#name : #PBMessageBrokerTest,
	#superclass : #TestCase,
	#instVars : [
		'broker',
		'handlerBlock',
		'handlerException',
		'settings',
		'stubServer'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #testing }
PBMessageBrokerTest class >> isAbstract [
	^ self == PBMessageBrokerTest
]

{ #category : #accessing }
PBMessageBrokerTest >> answer [
	self subclassResponsibility
]

{ #category : #accessing }
PBMessageBrokerTest >> answer: aDictionary [
	self subclassResponsibility
]

{ #category : #acessing }
PBMessageBrokerTest >> brokerUri [
	^ 'http://' , settings pharoSocketAddress printAddress
]

{ #category : #initialization }
PBMessageBrokerTest >> buildAndStartStubServer [
	self subclassResponsibility
]

{ #category : #utils }
PBMessageBrokerTest >> decodeAnswer: jsonText [
	self subclassResponsibility
]

{ #category : #running }
PBMessageBrokerTest >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6538)
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: 6539)
]

{ #category : #utils }
PBMessageBrokerTest >> errorResponse [
]

{ #category : #hooks }
PBMessageBrokerTest >> for: answerClass setCallback: aBlock [
	^ broker addCallback: aBlock answerClass: answerClass
]

{ #category : #initialization }
PBMessageBrokerTest >> initialize [
	super initialize.
	handlerBlock := [ :r |  ]
]

{ #category : #hooks }
PBMessageBrokerTest >> messageBrokerClass [
	self subclassResponsibility
]

{ #category : #acessing }
PBMessageBrokerTest >> pythonUri [
	^ 'http://' , settings pythonSocketAddress printAddress
]

{ #category : #utils }
PBMessageBrokerTest >> sendMessageToBroker: dict [
	self subclassResponsibility
]

{ #category : #acessing }
PBMessageBrokerTest >> setHandler: aBlock [
	handlerBlock := aBlock
]

{ #category : #running }
PBMessageBrokerTest >> setUp [
	super setUp.
	settings := self defaultSettings.
	broker := self messageBrokerClass settings: settings.
	broker start.
	self buildAndStartStubServer
]

{ #category : #running }
PBMessageBrokerTest >> stopStubServer [
	self subclassResponsibility 
]

{ #category : #running }
PBMessageBrokerTest >> tearDown [
	broker ifNotNil: [ broker stop ].
	self stopStubServer
]

{ #category : #tests }
PBMessageBrokerTest >> testEnqueueCommandMessage [
	| flag msg |
	flag := false.
	msg := PBEnqueueMessage 
				commandId: '7365'
				statements: 'foo().cat()'
				bindings: { #foo -> 42 . #bar -> 'zork' } asDictionary.
	self setHandler: [ :assoc | | bindings |
		self assert: assoc key equals: PBEnqueueMessage type.
		self assert: assoc value size equals: 4.
		self assert: (assoc value at: 'type') equals: PBEnqueueMessage type.
		self assert: (assoc value at: 'commandId') equals: '7365'.
		self assert: (assoc value at: 'statements') equals: 'foo().cat()'.
		bindings := assoc value at: 'bindings'.
		self assert: bindings size equals: 2.
		self assert: (bindings at: 'foo') equals: 42.
		self assert: (bindings at: 'bar') equals: 'zork'.
		flag := true.
		self answer ].
	broker sendMessage: msg.
	self assert: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testErrorOnCallback [
	| flag |
	flag := false.
	self for: PBEvalAnswer setCallback: [ :dict |
		Error signal.
		flag := true ].
	self should: [ 
			self sendMessageToBroker: { 
				#type -> PBEvalAnswer type.
				#value -> 'foobar' } asDictionary ]
		raise: PBCommunicationError.
	self deny: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testEvalAnswer [
	| flag |
	flag := false.
	self for: PBEvalAnswer setCallback: [ :dict |
		self assert: (dict at: #type) equals: PBEvalAnswer type.
		self assert: (dict at: #value) equals: 'foobar'.
		flag := true.
		PBEvalAnswer new ].
	self sendMessageToBroker: { 
				#type -> PBEvalAnswer type.
				#value -> 'foobar' } asDictionary.
	self assert: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testIsAliveMessage [
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
PBMessageBrokerTest >> testIsRunning [
	self assert: broker isRunning
]

{ #category : #tests }
PBMessageBrokerTest >> testWrongRouteAnswer [
	| flag |
	flag := false.
	self for: PBEvalAnswer setCallback: [ :dict |
		flag := true.
		self answer ].
	self 
		should: [ self sendMessageToBroker: { #type -> PBCallbackAnswer type } asDictionary ] 
		raise: PBCommunicationError.
	self deny: flag
]
