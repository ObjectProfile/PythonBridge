Class {
	#name : #PBIsAliveAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBIsAliveAnswer class >> fromDict: dict [
	^ self new
]

{ #category : #accessing }
PBIsAliveAnswer class >> messageClass [
	^ PBIsAliveMessage
]

{ #category : #encoding }
PBIsAliveAnswer >> privateEncode: dict [
]
