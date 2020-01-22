Class {
	#name : #PBLoggingHandler,
	#superclass : #PBHandler,
	#instVars : [
		'logs'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBLoggingHandler >> errorLogs [
	^ logs select: #isError
]

{ #category : #initialization }
PBLoggingHandler >> initialize [
	super initialize.
	logs := OrderedCollection new
]

{ #category : #log }
PBLoggingHandler >> log: aLog [
	logs add: aLog
]

{ #category : #accessing }
PBLoggingHandler >> logs [
	^ logs
]
