Class {
	#name : #PBPharoProcessTest,
	#superclass : #PBProcessTest,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #utils }
PBPharoProcessTest >> createTmpPythonFile [
	| file |
	file := FileLocator workingDirectory / 'tmp.py'.
	file writeStream close.
	^ file
]

{ #category : #utils }
PBPharoProcessTest >> destroyTmpFile: aFile [
	aFile deleteIfAbsent: [  ]
]

{ #category : #hooks }
PBPharoProcessTest >> processClass [
	^ PBPharoPipenvProcess
]
