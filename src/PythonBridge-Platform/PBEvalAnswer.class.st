Class {
	#name : #PBEvalAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBEvalAnswer class >> fromDict: dict [
	^ self new
]

{ #category : #accessing }
PBEvalAnswer class >> messageClass [
	^ PBEvalMessage 
]

{ #category : #encoding }
PBEvalAnswer >> privateEncode: dict [
]
