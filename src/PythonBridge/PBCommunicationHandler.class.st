Class {
	#name : #PBCommunicationHandler,
	#superclass : #PBHandler,
	#instVars : [
		'pharoPort',
		'pythonPort'
	],
	#category : #PythonBridge
}

{ #category : #initialization }
PBCommunicationHandler >> initialize [
	super initialize.
	pharoPort := 6777.
	pythonPort := 6778
]

{ #category : #testing }
PBCommunicationHandler >> isPythonReady [
	^ [ (ZnEasy get: 'http://localhost:' , self pythonPort asString , '/status') status = 200 ]
		on: Error do: [ :err | false ]
]

{ #category : #accessing }
PBCommunicationHandler >> pharoPort [
	^ pharoPort
]

{ #category : #accessing }
PBCommunicationHandler >> pharoPort: anObject [
	pharoPort := anObject
]

{ #category : #accessing }
PBCommunicationHandler >> pythonPort [
	^ pythonPort
]

{ #category : #accessing }
PBCommunicationHandler >> pythonPort: anObject [
	pythonPort := anObject
]

{ #category : #'as yet unclassified' }
PBCommunicationHandler >> sendPath: path data: data [
	| ans |
	ans := ZnEasy
		post: 'http://localhost:' , self pythonPort asString , path
		data: (ZnEntity text: data).
	ans status = 200 ifFalse: [ Error signal: 'Command rejected by python' ]
]
