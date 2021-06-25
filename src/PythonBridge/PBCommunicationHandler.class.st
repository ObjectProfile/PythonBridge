Class {
	#name : #PBCommunicationHandler,
	#superclass : #PBHandler,
	#instVars : [
		'messageBroker'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #adding }
PBCommunicationHandler >> addHandler: aBlock forMessageClass: messageClass [
	^ messageBroker addCallback: aBlock messageClass: messageClass
]

{ #category : #initialization }
PBCommunicationHandler >> initializeHandler [
	super initializeHandler.
	messageBroker := PBPlatform current messageBroker: self application settings
]

{ #category : #testing }
PBCommunicationHandler >> isPythonReady [
	| semaphore ans |
	semaphore := Semaphore new.
	[ ans := [self sendMessage: PBIsAliveMessage new.
				true ] 
					on: PBCommunicationError, PrimitiveFailed
					do: [ :e | false ].
	semaphore signal ] forkAt: Processor lowIOPriority.
	semaphore waitTimeoutMSecs: 100.
	^ ans notNil and: ans
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
