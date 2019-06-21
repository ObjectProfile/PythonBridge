Class {
	#name : #PBManualProcess,
	#superclass : #PBAbstractProcess,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #accessing }
PBManualProcess class >> workingDirectory [
	^ FileLocator workingDirectory
]
