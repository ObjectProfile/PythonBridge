Class {
	#name : #PBUtils,
	#superclass : #Object,
	#category : #'PythonBridge-Core'
}

{ #category : #'instance creation' }
PBUtils class >> newP3Variable [
	^ self newP3VariableName asP3GI
]

{ #category : #'instance creation' }
PBUtils class >> newP3VariableName [
	^ PBPlatform current newRandomName
]
