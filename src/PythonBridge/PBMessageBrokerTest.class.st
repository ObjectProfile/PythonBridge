Class {
	#name : #PBMessageBrokerTest,
	#superclass : #TestCase,
	#instVars : [
		'broker',
		'handlerBlock',
		'handlerException',
		'settings'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #testing }
PBMessageBrokerTest class >> isAbstract [
	^ self == PBMessageBrokerTest
]

{ #category : #accessing }
PBMessageBrokerTest >> answer: aDictionary [
	self subclassResponsibility
]

{ #category : #utils }
PBMessageBrokerTest >> assertCommunicationError: aBlock [
	self should: aBlock raise: PBCommunicationError
]

{ #category : #accessing }
PBMessageBrokerTest >> brokerUri [
	^ 'http://' , settings pharoSocketAddress printAddress
]

{ #category : #initialization }
PBMessageBrokerTest >> buildAndStartStubServer [
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
PBMessageBrokerTest >> for: messageClass setCallback: aBlock [
	^ broker addCallback: aBlock messageClass: messageClass
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

{ #category : #accessing }
PBMessageBrokerTest >> pythonUri [
	^ 'http://' , settings pythonSocketAddress printAddress
]

{ #category : #utils }
PBMessageBrokerTest >> sendMessageToBroker: dict [
	self subclassResponsibility
]

{ #category : #utils }
PBMessageBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	self subclassResponsibility
]

{ #category : #utils }
PBMessageBrokerTest >> sendMessageToBroker: dict answerEquals: ansDict [
	| flag |
	flag := false.
	self sendMessageToBroker: dict answerBlock: [ :aDict |
		flag := true.
		self assert: aDict equals: ansDict ].
	self sleepAWhile.
	self assert: flag
]

{ #category : #accessing }
PBMessageBrokerTest >> setHandler: aBlock [
	handlerBlock := aBlock
]

{ #category : #running }
PBMessageBrokerTest >> setUp [
	super setUp.
	settings := self defaultSettings.
	broker := self messageBrokerClass settings: settings.
	broker start.
	self buildAndStartStubServer.
	self sleepAWhile
]

{ #category : #utils }
PBMessageBrokerTest >> sleepAWhile [
	"Sleeping for a while so the async message has a chance to perform a change."
	self subclassResponsibility
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
	msg := PBEnqueueCommandMessage 
				commandId: '7365'
				statements: 'foo().cat()'
				bindings: { #foo -> 42 . #bar -> 'zork' } asDictionary.
	self setHandler: [ :assoc | | bindings |
		self assert: assoc key equals: PBEnqueueCommandMessage type.
		self assert: assoc value size equals: 4.
		self assert: (assoc value at: 'type') equals: PBEnqueueCommandMessage type.
		self assert: (assoc value at: 'commandId') equals: '7365'.
		self assert: (assoc value at: 'statements') equals: 'foo().cat()'.
		bindings := assoc value at: 'bindings'.
		self assert: bindings size equals: 2.
		self assert: (bindings at: 'foo') equals: 42.
		self assert: (bindings at: 'bar') equals: 'zork'.
		flag := true ].
	broker sendMessage: msg.
	self sleepAWhile.
	self assert: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testErrorOnCallback [
	| flag |
	flag := false.
	self for: PBRSyncMessage setCallback: [ :msg |
		Error signal.
		flag := true ].
	self assertCommunicationError: [ 
			self 
				sendMessageToBroker: { 
					#type -> PBRSyncMessage type.
					#__sync -> 'foobar' } asDictionary
				answerBlock: [  ] ].
	self deny: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testEvalAnswer [
	| flag |
	flag := false.
	self for: PBUpdatePromiseMessage setCallback: [ :msg |
		self assert: msg type equals: PBUpdatePromiseMessage type.
		self assert: msg value equals: 'foobar'.
		self assert: msg promiseId equals: '4fcb36d'.
		flag := true ].
	self sendMessageToBroker: { 
				#type -> PBUpdatePromiseMessage type.
				#id -> '4fcb36d'.
				#value -> 'foobar' } asDictionary.
	self assert: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testIsAliveMessage [
	| flag msg |
	flag := false.
	self setHandler: [ :assoc |
		self assert: assoc key equals: PBIsAliveMessage type.
		self assert: assoc value associations size equals: 2.
		self assert: (assoc value at: #type) equals: PBIsAliveMessage type.
		self assert: (assoc value at: #__sync) equals: msg syncId.
		flag := true.
		self answer: { #type -> PBIsAliveMessage type. #__sync -> msg syncId } asDictionary ].
	msg := PBIsAliveMessage new.
	broker sendMessage: msg.
	self assert: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testIsRunning [
	self assert: broker isRunning
]

{ #category : #tests }
PBMessageBrokerTest >> testRMessageWithParams [
	| flag |
	flag := false.
	self for: PBCallbackMessage setCallback: [ :msg |
		flag := true.
		self assert: msg type equals: PBCallbackMessage type.
		self assert: msg commandId equals: 10.
		self assert: msg observerId equals: 'foo'.
		self assert: msg value equals: 'lalala'.
		self assert: msg syncId equals: 'zork'.
		msg createAnswer
			value: 13;
			yourself ].
	self 
		sendMessageToBroker: { 
			#type -> PBCallbackMessage type.
			#commandId -> 10.
			#observerId -> 'foo'.
			#value -> 'lalala'.
			#__sync -> 'zork' } asDictionary
		answerEquals: { 
			#type -> PBCallbackMessage type.
			#value -> 13.
			#__sync -> 'zork' } asDictionary.
	self assert: flag.
]

{ #category : #tests }
PBMessageBrokerTest >> testRSyncMessage [
	| flag |
	flag := false.
	self for: PBRSyncMessage setCallback: [ :msg |
		flag := true.
		msg createAnswer ].
	self 
		sendMessageToBroker: { 
			#type -> PBRSyncMessage type.
			#__sync -> 'foobar' } asDictionary
		answerEquals: { 
			#type -> PBRSyncMessage type.
			#__sync -> 'foobar' } asDictionary.
	self assert: flag.
]

{ #category : #tests }
PBMessageBrokerTest >> testSyncMessage [
	| flag msg ans |
	flag := false.
	self setHandler: [ :assoc |
		self assert: assoc key equals: PBSyncMessage type.
		self assert: assoc value associations size equals: 2.
		self assert: (assoc value at: #type) equals: PBSyncMessage type.
		self assert: (assoc value at: #__sync) equals: msg syncId.
		flag := true.
		self answer: { #type -> PBSyncMessage type . #__sync -> msg syncId } asDictionary ].
	msg := PBSyncMessage new.
	ans := broker sendMessage: msg.
	self assert: ans message equals: msg.
	self assert: flag
]

{ #category : #tests }
PBMessageBrokerTest >> testWrongRouteAnswer [
	| flag |
	flag := false.
	self for: PBCallbackMessage setCallback: [ :dict |
		flag := true ].
	self assertCommunicationError:  [ self sendMessageToBroker: { 
								#type -> PBRSyncMessage type.
								#__sync -> 'foobar' } asDictionary ].
	self deny: flag
]
