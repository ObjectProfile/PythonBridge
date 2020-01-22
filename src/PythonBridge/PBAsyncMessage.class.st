Class {
	#name : #PBAsyncMessage,
	#superclass : #PBMessage,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBAsyncMessage class >> type [
	^ #ASYNC
]

{ #category : #testing }
PBAsyncMessage >> isSync [
	^ false
]
