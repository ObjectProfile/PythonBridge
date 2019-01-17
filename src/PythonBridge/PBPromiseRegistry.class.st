Class {
	#name : #PBPromiseRegistry,
	#superclass : #Object,
	#instVars : [
		'promiseTable',
		'semaphore'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #adding }
PBPromiseRegistry >> addPromise: aPromise [
	semaphore critical: [ promiseTable at: aPromise id put: aPromise ]
]

{ #category : #initialization }
PBPromiseRegistry >> initialize [
	super initialize.
	promiseTable := Dictionary new.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #'private - testing' }
PBPromiseRegistry >> promiseTable [
	^ promiseTable
]

{ #category : #adding }
PBPromiseRegistry >> removeAndSignalPromiseId: id with: anObject [
	self signalPromiseId: id with: anObject.
	self removePromiseId: id
]

{ #category : #adding }
PBPromiseRegistry >> removePromiseId: id [
	semaphore critical: [ promiseTable removeKey: id ]
]

{ #category : #adding }
PBPromiseRegistry >> signalPromiseId: id with: anObject [
	| promise |
	semaphore critical: [ 
		promise := promiseTable at: id.
		promise signalWithValue: anObject ]
]
