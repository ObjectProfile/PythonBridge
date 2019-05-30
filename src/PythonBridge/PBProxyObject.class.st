Class {
	#name : #PBProxyObject,
	#superclass : #PBObject,
	#instVars : [
		'pythonClass',
		'application'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBProxyObject class >> pythonClass: pythonClass pythonVar: pyVar application: application [
	^ self new
		pythonVariable: pyVar;
		pythonClass: pythonClass;
		application: application;
		yourself
]

{ #category : #accessing }
PBProxyObject >> application [
	^ application
]

{ #category : #accessing }
PBProxyObject >> application: anObject [
	application := anObject
]

{ #category : #accessing }
PBProxyObject >> applicationClass [
	^ self application class
]

{ #category : #hooks }
PBProxyObject >> createObject [
	self shouldNotImplement
]

{ #category : #accessing }
PBProxyObject >> pythonClass [
	^ pythonClass
]

{ #category : #accessing }
PBProxyObject >> pythonClass: anObject [
	pythonClass := anObject
]

{ #category : #accessing }
PBProxyObject >> pythonVariable: pyVar [
	pythonVariable := pyVar
]
