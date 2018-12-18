Class {
	#name : #PBPromise,
	#superclass : #Object,
	#instVars : [
		'id',
		'semaphore',
		'transformBlock',
		'value'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBPromise class >> id: id [
	^ self new
			id: id;
			yourself
]

{ #category : #accessing }
PBPromise >> id [
	^ id
]

{ #category : #accessing }
PBPromise >> id: anObject [
	id := anObject
]

{ #category : #initialization }
PBPromise >> initialize [
	super initialize.
	semaphore := Semaphore new.
	value := nil.
	transformBlock := #yourself
]

{ #category : #signalling }
PBPromise >> isSignaled [
	^ semaphore isSignaled
]

{ #category : #signalling }
PBPromise >> signalAll [
	1 to: semaphore size + 20 do: [ :s | semaphore signal ]
]

{ #category : #signalling }
PBPromise >> signalWithValue: anObject [
	value := transformBlock value: anObject.
	self signalAll.
]

{ #category : #accessing }
PBPromise >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
PBPromise >> transformBlock: anObject [
	transformBlock := anObject
]

{ #category : #signalling }
PBPromise >> value [
	^ value
]

{ #category : #signalling }
PBPromise >> waitForValue [
	self isSignaled ifTrue: [ ^ self value ].
	semaphore wait.
	^ self value
]
