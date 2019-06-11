Class {
	#name : #PBCallbackAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBCallbackAnswer class >> messageClass [
	^ PBCallbackMessage
]
