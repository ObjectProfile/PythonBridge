Class {
	#name : #PBCallbackMessage,
	#superclass : #PBMessage,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBCallbackMessage class >> type [
	^ 'CALLBACK'
]
