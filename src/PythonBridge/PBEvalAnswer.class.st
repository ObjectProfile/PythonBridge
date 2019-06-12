Class {
	#name : #PBEvalAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #accessing }
PBEvalAnswer class >> type [
	^ 'EVAL'
]

{ #category : #encoding }
PBEvalAnswer >> privateEncode: dict [
]
