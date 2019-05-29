Class {
	#name : #PBErrorAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBErrorAnswer class >> messageClass [
	^ PBErrorMessage
]
