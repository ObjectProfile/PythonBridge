Class {
	#name : #PBPharoPipenvPlatform,
	#superclass : #PBPharoPlatform,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #accessing }
PBPharoPipenvPlatform class >> priority [
	^ 10
]

{ #category : #hooks }
PBPharoPipenvPlatform class >> processClass [
	^ PBPharoPipenvProcess
]
