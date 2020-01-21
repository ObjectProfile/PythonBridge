Class {
	#name : #PBBlockFinalizer,
	#superclass : #PBAbstractFinalizer,
	#instVars : [
		'block'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBBlockFinalizer class >> block: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #accessing }
PBBlockFinalizer >> block [
	^ block
]

{ #category : #accessing }
PBBlockFinalizer >> block: anObject [
	block := anObject
]

{ #category : #finalization }
PBBlockFinalizer >> finalize [
	^ block value
]
