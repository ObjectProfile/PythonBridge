Class {
	#name : #PBMsgPackPharoBrokerTest,
	#superclass : #PBMessageBrokerTest,
	#instVars : [
		'stubStream',
		'stubThread'
	],
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #utils }
PBMsgPackPharoBrokerTest >> answer [
	"MsgPack socket broker does not answer empty messages."
]

{ #category : #utils }
PBMsgPackPharoBrokerTest >> answer: dict [
	self primSendMessageToBroker: dict
]

{ #category : #utils }
PBMsgPackPharoBrokerTest >> assertCommunicationError: aBlock [
	"Message pack does not raise CommunicationError on exceptions at the other side"
]

{ #category : #running }
PBMsgPackPharoBrokerTest >> buildAndStartStubServer [
	stubStream := PBMsgPackUtils openConnectionToHost: #[ 127 0 0 1 ] port: broker port.
	stubStream := PBMsgPackSocketStream on: stubStream.
	stubThread := [	
		[ true ] whileTrue: [ 
			self stubPrimHandle: stubStream next ] ] forkAt: Processor lowIOPriority.
	
]

{ #category : #utils }
PBMsgPackPharoBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #hooks }
PBMsgPackPharoBrokerTest >> messageBrokerClass [
	^ PBMsgPackPharoBroker
]

{ #category : #private }
PBMsgPackPharoBrokerTest >> primSendMessageToBroker: dict [
	stubStream nextPut: dict
]

{ #category : #hooks }
PBMsgPackPharoBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerBlock: [ :ans | self assert: false ]
]

{ #category : #hooks }
PBMsgPackPharoBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	self setHandler: aBlock.
	self primSendMessageToBroker: dict.
	self sleepAWhile.
]

{ #category : #utils }
PBMsgPackPharoBrokerTest >> sendMessageToBroker: dict answerEquals: ansDict [
	| flag |
	flag := false.
	self sendMessageToBroker: dict answerBlock: [ :anAssoc |
		flag := true.
		self assert: anAssoc value equals: ansDict ].
	self sleepAWhile.
	self assert: flag
]

{ #category : #utils }
PBMsgPackPharoBrokerTest >> sleepAWhile [
	(Delay forMilliseconds: 50) wait
]

{ #category : #running }
PBMsgPackPharoBrokerTest >> stopStubServer [
	stubThread ifNotNil: [ stubThread terminate ].
	stubStream ifNotNil: [ stubStream close ]
]

{ #category : #private }
PBMsgPackPharoBrokerTest >> stubPrimHandle: msgDict [
	handlerBlock value: (msgDict at: #type) -> msgDict
]
