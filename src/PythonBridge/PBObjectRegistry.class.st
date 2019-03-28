Class {
	#name : #PBObjectRegistry,
	#superclass : #Object,
	#instVars : [
		'objectTable',
		'semaphore',
		'idTable'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #'as yet unclassified' }
PBObjectRegistry >> hasId: anId [
	^ semaphore critical: [ idTable includesKey: anId ]
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> idTable [
	^ idTable
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> initialize [
	super initialize.
	idTable := WeakValueDictionary new.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> registerObject: anObject [
	semaphore critical: [ 
		idTable at: anObject id put: anObject ]
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> resolve: anId [
	^ semaphore critical: [ idTable at: anId ]
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> resolve: anId ifAbsent: aBlock [
	| obj |
	obj := semaphore critical: [ idTable at: anId ifAbsent: [ nil ] ].
	^ obj ifNil: aBlock.
	
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> unregisterId: anId [
	semaphore critical: [ idTable removeKey: anId ]
]

{ #category : #'as yet unclassified' }
PBObjectRegistry >> unregisterObject: anObject [
	semaphore critical: [ idTable removeKey: anObject id ]
]
