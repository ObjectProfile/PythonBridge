Class {
	#name : #PBEvalAnswer,
	#superclass : #PBAnswer,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBEvalAnswer class >> type [
	^ 'EVAL'
]

{ #category : #encoding }
PBEvalAnswer >> privateEncode: dict [
]
