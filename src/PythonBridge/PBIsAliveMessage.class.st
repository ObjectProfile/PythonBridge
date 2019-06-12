Class {
	#name : #PBIsAliveMessage,
	#superclass : #PBMessage,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBIsAliveMessage class >> type [
	^ 'IS_ALIVE'
]

{ #category : #encoding }
PBIsAliveMessage >> privateEncode: dict [
	
]
