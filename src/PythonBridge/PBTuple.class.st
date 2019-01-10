Class {
	#name : #PBTuple,
	#superclass : #OrderedCollection,
	#category : #'PythonBridge-P3Generator'
}

{ #category : #writing }
PBTuple >> writePython3On: aStream [
	aStream << '('.
	self 
		do: [ :elem | 
			elem writePython3On: aStream.
			aStream << ',' ].
	aStream << ')'.
]
