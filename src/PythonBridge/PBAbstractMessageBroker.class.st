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

{ #category : #messaging }
PBAbstractMessageBroker >> addCallback: aBlock answerClass: answerCls [
	messageCallbacks at: answerCls put: aBlock
]

{ #category : #messaging }
PBAbstractMessageBroker >> decode: request [
	self subclassResponsibility
]

{ #category : #messaging }
PBAbstractMessageBroker >> encode: aMessage [
	self subclassResponsibility
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
	^ PBAnswer resolveMessageClassFromType: aType
]

{ #category : #messaging }
PBAbstractMessageBroker >> sendMessage: aMessage [
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
