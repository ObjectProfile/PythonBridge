Class {
	#name : #PBAbstractMessageBroker,
	#superclass : #Object,
	#instVars : [
		'debugMode',
		'messageCallbacks',
		'settings'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBAbstractMessageBroker class >> settings: settings [
	^ self new
		settings: settings;
		yourself
]

{ #category : #messaging }
PBAbstractMessageBroker >> addCallback: aBlock answerClass: answerCls [
	messageCallbacks at: answerCls put: aBlock
]

{ #category : #messaging }
PBAbstractMessageBroker >> addCallback: aBlock messageClass: messageClass [
	messageCallbacks at: messageClass put: aBlock
]

{ #category : #private }
PBAbstractMessageBroker >> handle: dict reverseMessageClass: msgClass [
	| handler |
	(messageCallbacks includesKey: msgClass) ifFalse: [ PBCommunicationError signal ].
	handler := PBMessageHandler 
						forMessage: (msgClass decodeFrom: dict) 
						callback: (messageCallbacks at: msgClass).
	handler handleMessage.
	^ handler
]

{ #category : #initialization }
PBAbstractMessageBroker >> initialize [
	super initialize.
	messageCallbacks := Dictionary new.
	debugMode := false
]

{ #category : #testing }
PBAbstractMessageBroker >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractMessageBroker >> port [
	^ settings pharoSocketAddress port
]

{ #category : #accessing }
PBAbstractMessageBroker >> pythonUri [
	^ 'http://' , settings pythonSocketAddress printAddress
]

{ #category : #private }
PBAbstractMessageBroker >> resolveMessageFromType: aType [
	^ PBAbstractMessage withAllSubclasses 
			detect: [ :cls | cls type = aType ] 
			ifNone: [ Error signal: 'Message ' , aType , ' not understood.' ].
]

{ #category : #messaging }
PBAbstractMessageBroker >> sendAsyncMessage: aMessage [
	self subclassResponsibility
]

{ #category : #messaging }
PBAbstractMessageBroker >> sendMessage: aMessage [
	^ aMessage isSync
		ifTrue: [ self sendSyncMessage: aMessage ]
		ifFalse: [ self sendAsyncMessage: aMessage ]
]

{ #category : #messaging }
PBAbstractMessageBroker >> sendSyncMessage: aMessage [
	self subclassResponsibility
]

{ #category : #accessing }
PBAbstractMessageBroker >> setDebugMode [
	debugMode := true.
]

{ #category : #accessing }
PBAbstractMessageBroker >> settings [
	^ settings
]

{ #category : #accessing }
PBAbstractMessageBroker >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
PBAbstractMessageBroker >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
PBAbstractMessageBroker >> stop [
	self subclassResponsibility
]
