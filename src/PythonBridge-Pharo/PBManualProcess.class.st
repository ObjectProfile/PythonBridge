Class {
	#name : #PBManualProcess,
	#superclass : #PBAbstractProcess,
	#category : #'PythonBridge-Pharo-Processes'
}

{ #category : #accessing }
PBManualProcess class >> workingDirectory [
	^ FileLocator workingDirectory
]
