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
PBApplicationTest >> applicationClass [
	^ PBApplication
]
