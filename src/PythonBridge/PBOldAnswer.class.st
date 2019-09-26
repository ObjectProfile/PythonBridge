Class {
	#name : #PBOldAnswer,
	#superclass : #PBOldMessage,
	#category : #'PythonBridge-Platform-Messages-Old'
}

{ #category : #accessing }
PBOldAnswer class >> decode: dict [
	| type ansCls |
	type := dict at: #type.
	ansCls := self withAllSubclasses detect: [ :cls | cls type = type ].
	^ ansCls fromDict: dict
]

{ #category : #accessing }
PBOldAnswer class >> messageClass [
	^ PBOldMessage
]

{ #category : #accessing }
PBOldAnswer class >> resolveMessageClassFromType: aString [
	^ self withAllSubclasses detect: [ :cls | cls type = aString ] ifNone: [ PBOldAnswer ].
]

{ #category : #accessing }
PBOldAnswer class >> type [
	^ 'ANSWER'
]

{ #category : #accessing }
PBOldAnswer >> type [
	^ self class type
]
