Class {
	#name : #PBSettings,
	#superclass : #Object,
	#instVars : [
		'pharoSocketAddress',
		'pythonSocketAddress'
	],
	#category : #'PythonBridge-Platform-Pharo'
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
PBSettings >> pythonSocketAddress [
	^ pythonSocketAddress
]

{ #category : #accessing }
PBSettings >> pythonSocketAddress: anObject [
	pythonSocketAddress := anObject
]
