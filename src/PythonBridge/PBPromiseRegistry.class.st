Class {
	#name : #PBPromiseRegistry,
	#superclass : #Object,
	#instVars : [
		'promiseTable'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #adding }
PBPromiseRegistry >> addPromise: aPromise [
	promiseTable at: aPromise id put: aPromise
]

{ #category : #initialization }
PBPromiseRegistry >> initialize [
	super initialize.
	promiseTable := Dictionary new
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
	promiseTable removeKey: id
]

{ #category : #adding }
PBPromiseRegistry >> signalPromiseId: id with: anObject [
	| promise |
	promise := promiseTable at: id.
	promise signalWithValue: anObject
]
