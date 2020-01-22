Class {
	#name : #PBPromiseRegistryTest,
	#superclass : #TestCase,
	#instVars : [
		'registry'
	],
	#category : #'PythonBridge-Tests'
}

{ #category : #initialization }
PBPromiseRegistryTest >> setUp [
	registry := PBPromiseRegistry new
]

{ #category : #initialization }
PBPromiseRegistryTest >> testAddPromise [
	registry addPromise: (PBPromise id: '123').
	self assert: registry promiseTable size equals: 1.
	self assert: registry promiseTable anyOne id equals: '123'
]

{ #category : #initialization }
PBPromiseRegistryTest >> testRemovePromiseId [
	registry addPromise: (PBPromise id: '123').
	registry removePromiseId: '123'.
	self assert: registry promiseTable size equals: 0
]

{ #category : #initialization }
PBPromiseRegistryTest >> testSignalPromise [
	| semaphore flag promise |
	semaphore := Semaphore new.
	flag := false.
	promise := (PBPromise id: '123').
	registry addPromise: promise.
	[ 	
		self assert: promise waitForValue equals: #foo.
		flag := true.
		semaphore signal. ] fork.
	registry signalPromiseId: '123' with: #foo.
	semaphore wait.
	self assert: flag
]

{ #category : #initialization }
PBPromiseRegistryTest >> testSignalPromiseWithTransformBlock [
	| semaphore flag promise |
	semaphore := Semaphore new.
	flag := false.
	promise := (PBPromise id: '123')
						transformBlock: [ :obj | 55 ].
	registry addPromise: promise.
	[ 	
		self assert: promise waitForValue equals: 55.
		flag := true.
		semaphore signal. ] fork.
	registry signalPromiseId: '123' with: #foo.
	semaphore wait.
	self assert: flag
]
