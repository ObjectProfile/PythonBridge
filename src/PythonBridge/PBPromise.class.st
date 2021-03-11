Class {
	#name : #PBPromise,
	#superclass : #Object,
	#instVars : [
		'id',
		'semaphore',
		'transformBlock',
		'value',
		'waitAgain'
	],
	#category : #'PythonBridge-Execution'
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
PBPromise >> setWaitAgain [ 
	"Flag that the promise should wait for the real value to be returned from the server"
StringSignal emit: 'setWaitAgain: ', self identityHash asString.
	waitAgain := true.
	semaphore consumeAllSignals.
]

{ #category : #signalling }
PBPromise >> signalAll [
	1 to: semaphore size + 20 do: [ :s | semaphore signal ]
]

{ #category : #signalling }
PBPromise >> signalWithValue: anObject [
	"Set the receiver's value and signal the value is available"

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

	[ waitAgain := false.
	self isSignaled ifFalse: [ semaphore wait ].
	(value isKindOf: Exception) ifTrue:
		[ value promise: self.
		value signal ].
	"If an exception was signalled, it may request that the promise wait for the real value to come through."
	waitAgain ] whileTrue.
	^ value
]
