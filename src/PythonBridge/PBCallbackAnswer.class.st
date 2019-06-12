Class {
	#name : #PBCallbackAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBCallbackAnswer class >> type [
	^ 'CALLBACK'
]

{ #category : #encoding }
PBCallbackAnswer >> privateEncode: dict [
]
