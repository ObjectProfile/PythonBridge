Class {
	#name : #PBApplicationTest,
	#superclass : #PBTestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #accessing }
PBApplicationTest class >> appResource [
	^ PBApplicationTestResource
]

{ #category : #initialization }
PBApplicationTest >> application [
	^ PBApplication uniqueInstance
]

{ #category : #initialization }
PBApplicationTest >> cf [
	^ PBCF
]

{ #category : #initialization }
PBApplicationTest >> setUp [
	self cf reset
]
