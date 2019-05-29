Class {
	#name : #PBEnqueueAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBEnqueueAnswer class >> fromDict: dict [
	^ self new
]

{ #category : #accessing }
PBEnqueueAnswer class >> messageClass [
	^ PBEnqueueMessage 
]

{ #category : #encoding }
PBEnqueueAnswer >> privateEncode: dict [
]
