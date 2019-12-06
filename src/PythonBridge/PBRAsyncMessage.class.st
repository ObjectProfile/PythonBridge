Class {
	#name : #PBRAsyncMessage,
	#superclass : #PBRMessage,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBRAsyncMessage class >> type [
	^ #RASYNC
]

{ #category : #testing }
PBRAsyncMessage >> isSync [
	^ false
]
