Class {
	#name : #PBLog,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBLog class >> message: aString [
	^ self new
		message: aString;
		yourself
]

{ #category : #testing }
PBLog >> isError [
	^ false
]

{ #category : #accessing }
PBLog >> message [
	^ message
]

{ #category : #accessing }
PBLog >> message: anObject [
	message := anObject
]

{ #category : #printing }
PBLog >> printOn: str [
	message
		ifNil: [ super printOn: str ]
		ifNotNil: [
			str 
				<< self class name; 
				<< ': ';
				<< message;
				cr ]
]
