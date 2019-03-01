Class {
	#name : #PBCommunicationHandler,
	#superclass : #PBHandler,
	#instVars : [
		'pharoPort',
		'pythonPort',
		'routes',
		'server'
	],
	#classVars : [
		'PharoPortGenerator',
		'PythonPortGenerator'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #accessing }
PBCommunicationHandler class >> pharoPortGenerator [
	^ PharoPortGenerator
]

{ #category : #accessing }
PBCommunicationHandler class >> pharoPortGenerator: anObject [
	PharoPortGenerator := anObject
]

{ #category : #accessing }
PBCommunicationHandler class >> pythonPortGenerator [
	^ PythonPortGenerator
]

{ #category : #accessing }
PBCommunicationHandler class >> pythonPortGenerator: anObject [
	PythonPortGenerator := anObject
]

{ #category : #adding }
PBCommunicationHandler >> addRoute: aPath block: aBlock [
	routes add: (aPath -> aBlock)
]

{ #category : #converting }
PBCommunicationHandler >> decode: req [
	^ NeoJSONReader fromString: req contents
]

{ #category : #initialization }
PBCommunicationHandler >> initialize [
	super initialize.
	pharoPort := self class pharoPortGenerator value.
	pythonPort := self class pythonPortGenerator value.
	routes := OrderedCollection new
]

{ #category : #initialization }
PBCommunicationHandler >> initializeHandler [
	super initializeHandler.
	
]

{ #category : #testing }
PBCommunicationHandler >> isPythonReady [
	^ [ (ZnEasy get: 'http://localhost:' , self pythonPort asString , '/status') status = 200 ]
		on: Error do: [ :err | false ]
]

{ #category : #accessing }
PBCommunicationHandler >> pharoPort [
	^ pharoPort
]

{ #category : #accessing }
PBCommunicationHandler >> pharoPort: anObject [
	pharoPort := anObject
]

{ #category : #accessing }
PBCommunicationHandler >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: server process 
			ifAbsent: [  ] ]
]

{ #category : #accessing }
PBCommunicationHandler >> pythonPort [
	^ pythonPort
]

{ #category : #accessing }
PBCommunicationHandler >> pythonPort: anObject [
	pythonPort := anObject
]

{ #category : #'as yet unclassified' }
PBCommunicationHandler >> sendPath: path data: data [
	| ans |
	ans := ZnEasy
		post: 'http://localhost:' , self pythonPort asString , path
		data: (ZnEntity text: data).
	ans status = 200 ifFalse: [ Error signal: 'Command rejected by python' ]
]

{ #category : #accessing }
PBCommunicationHandler >> start [
	super start.
	server := ZnServer on: self pharoPort.
	server debugMode: true.
	server start.
	self preventTestForkedPDestroyServer.
	self
		assert: server isRunning & server isListening
		description:
			('Failed to start server on port {1}. Is there one already?'
				format: {server port}).
	server onRequestRespond: [ :req | 
		req method = #POST
			ifTrue: [ 
				routes 
					detect: [ :route | req uri asString = route key ] 
					ifFound: [ :route | | ans |
						ans := (route value value: (self decode: req)).
						ans class = ZnResponse 
							ifTrue: [ ans ]
							ifFalse: [ ZnResponse noContent ] ]
					ifNone: [ ZnResponse noContent ]  ]
			ifFalse: [ ZnResponse noContent ] ].
	
]

{ #category : #accessing }
PBCommunicationHandler >> stop [
	super stop.
	server ifNotNil: [ server stop ]
]
