Class {
	#name : #PBEvalMessage,
	#superclass : #PBMessage,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBEvalMessage class >> type [
	^ 'EVAL'
]
