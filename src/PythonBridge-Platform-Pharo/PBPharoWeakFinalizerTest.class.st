Class {
	#name : #PBPharoWeakFinalizerTest,
	#superclass : #PBWeakFinalizerTest,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #running }
PBPharoWeakFinalizerTest >> triggerGC [
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
]

{ #category : #running }
PBPharoWeakFinalizerTest >> weakRegistryClass [
	^ PBPharoWeakRegistry
]
