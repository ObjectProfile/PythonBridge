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
PBProxyObject class >> pythonClass: pythonClass application: application [
	^ self new
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

{ #category : #accessing }
PBProxyObject >> pythonClass [
	^ pythonClass
]

{ #category : #accessing }
PBProxyObject >> pythonClass: anObject [
	pythonClass := anObject
]
