Class {
	#name : #PBPharoWeakFinalizerTest,
	#superclass : #PBWeakFinalizerTest,
	#category : #'PythonBridge-Pharo-Platform'
}

{ #category : #running }
PBPharoWeakFinalizerTest >> triggerGC [
	Smalltalk garbageCollect.
	(Delay forMilliseconds: 100) wait.
	Smalltalk garbageCollect.
]

{ #category : #running }
PBPharoWeakFinalizerTest >> weakRegistryClass [
	^ PBPharoWeakRegistry
]
