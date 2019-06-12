Class {
	#name : #PBCommunicationHandler,
	#superclass : #PBHandler,
	#instVars : [
		'messageBroker'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #adding }
PBCommunicationHandler >> addHandler: aBlock forAnswerCls: answerCls [
	^ messageBroker addCallback: aBlock answerClass: answerCls
]

{ #category : #initialization }
PBCommunicationHandler >> initializeHandler [
	super initializeHandler.
	messageBroker := PBPlatform current messageBrokerClass settings: self application settings
]

{ #category : #testing }
PBCommunicationHandler >> isPythonReady [
	[ self sendMessage: PBIsAliveMessage new ] 
		on: PBCommunicationError 
		do: [ :e | ^ false ].
	^ true
]

{ #category : #adding }
PBCommunicationHandler >> sendMessage: aMessage [
	^ messageBroker sendMessage: aMessage
]

{ #category : #accessing }
PBCommunicationHandler >> start [
	^ messageBroker start
]

{ #category : #accessing }
PBCommunicationHandler >> stop [
	^ messageBroker stop
]
