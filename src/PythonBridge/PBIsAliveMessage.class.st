Class {
	#name : #PBIsAliveMessage,
	#superclass : #PBSyncMessage,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBIsAliveMessage class >> answerClass [
	^ PBAnswer
]

{ #category : #accessing }
PBIsAliveMessage class >> type [
	^ #IS_ALIVE
]
