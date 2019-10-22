Class {
	#name : #PBPharoProcessTest,
	#superclass : #PBProcessTest,
	#category : #'PythonBridge-Pharo-Processes'
}

{ #category : #utils }
PBPharoProcessTest >> createTmpPythonFile [
	| file |
	file := FileLocator workingDirectory / 'tmp.py'.
	file writeStream close.
	^ file
]

{ #category : #utils }
PBPharoProcessTest >> defaultTmpFile [
	^ 'tmp.py' asFileReference
]

{ #category : #utils }
PBPharoProcessTest >> destroyTmpFile: aFile [
	aFile deleteIfAbsent: [  ]
]

{ #category : #hooks }
PBPharoProcessTest >> processClass [
	^ PBPharoPipenvProcess
]
