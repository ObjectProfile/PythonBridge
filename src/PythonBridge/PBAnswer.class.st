Class {
	#name : #PBAnswer,
	#superclass : #PBMessage,
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBAnswer class >> decode: dict [
	| type ansCls |
	type := dict at: #type.
	ansCls := self withAllSubclasses detect: [ :cls | cls type = type ].
	^ ansCls fromDict: dict
]

{ #category : #accessing }
PBAnswer class >> messageClass [
	^ PBMessage
]

{ #category : #accessing }
PBAnswer class >> resolveMessageClassFromType: aString [
	^ self withAllSubclasses detect: [ :cls | cls type = aString ] ifNone: [ PBAnswer ].
]

{ #category : #accessing }
PBAnswer class >> type [
	^ 'ANSWER'
]

{ #category : #accessing }
PBAnswer >> type [
	^ self class type
]
