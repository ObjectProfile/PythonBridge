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

{ #category : #instructions }
PBPromiseRegistry >> notifyDebuggerPaused: aDebugger [
	"Notify all promises that the server debugger has paused in case the Bloc UI process is waiting on one of the promises."
	| signal promises |

	signal := PBDebuggerPaused new debugger: aDebugger.
	semaphore critical: [ promises := promiseTable values ].
	promises do: [ :promise |
		promise signalWithValue: signal copy ].
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
