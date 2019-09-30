Class {
	#name : #PBPharoMsgPackPharoBroker,
	#superclass : #PBAbstractMessageBroker,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #private }
PBPharoMsgPackPharoBroker >> handleRMessage: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	^ self handle: dict messageAnswerClass: msgClass
]

{ #category : #testing }
PBPharoMsgPackPharoBroker >> isRunning [
]

{ #category : #'start-stop' }
PBPharoMsgPackPharoBroker >> start [
	
]

{ #category : #'start-stop' }
PBPharoMsgPackPharoBroker >> stop [
	
]
