Class {
	#name : #PBSettings,
	#superclass : #Object,
	#instVars : [
		'pharoSocketAddress',
		'pythonSocketAddress',
		'pipenvPath',
		'workingDirectory'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBSettings class >> pharoSocketAddress: pharoSocketAddress pythonSocketAddress: pythonSocketAddress [
	^ self new
		pharoSocketAddress: pharoSocketAddress;
		pythonSocketAddress: pythonSocketAddress;
		yourself
]

{ #category : #accessing }
PBSettings >> pharoSocketAddress [
	^ pharoSocketAddress
]

{ #category : #accessing }
PBSettings >> pharoSocketAddress: anObject [
	pharoSocketAddress := anObject
]

{ #category : #accessing }
PBSettings >> pipenvPath [
	^ pipenvPath
]

{ #category : #accessing }
PBSettings >> pipenvPath: aFileReference [

	pipenvPath := aFileReference.
	pipenvPath ifNil: [ ^ self ].
	self assert: [ pipenvPath exists ].
]

{ #category : #accessing }
PBSettings >> pythonSocketAddress [
	^ pythonSocketAddress
]

{ #category : #accessing }
PBSettings >> pythonSocketAddress: anObject [
	pythonSocketAddress := anObject
]

{ #category : #accessing }
PBSettings >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PBSettings >> workingDirectory: aFileReference [

	workingDirectory := aFileReference.
	workingDirectory ifNil: [ ^ self ].
	self assert: [ workingDirectory exists ].
]
