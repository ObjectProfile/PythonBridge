Class {
	#name : #PBPharoPipenvPlatform,
	#superclass : #PBPharoPlatform,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #hooks }
PBPharoPipenvPlatform class >> processClass [
	^ PBPharoPipenvProcess
]
