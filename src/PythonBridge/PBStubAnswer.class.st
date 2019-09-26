Class {
	#name : #PBStubAnswer,
	#superclass : #PBAnswer,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #converting }
PBStubAnswer >> decode: dict [
	ivar1 := dict at: #ivar1.
	ivar2 := { dict at: #ivar2f } , (dict at: #ivar2r)
]

{ #category : #accessing }
PBStubAnswer >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
PBStubAnswer >> ivar2 [
	^ ivar2
]
