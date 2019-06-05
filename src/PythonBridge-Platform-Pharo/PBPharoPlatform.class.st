Class {
	#name : #PBPharoPlatform,
	#superclass : #PBPlatform,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #'as yet unclassified' }
PBPharoPlatform class >> messageBrokerClass [
	^ PBPharoMessageBroker
]
