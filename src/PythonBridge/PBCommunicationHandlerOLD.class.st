Class {
	#name : #PBCommunicationHandlerOLD,
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
PBCommunicationHandlerOLD class >> pharoPortGenerator [
	^ PharoPortGenerator
]

{ #category : #accessing }
PBCommunicationHandlerOLD class >> pharoPortGenerator: anObject [
	PharoPortGenerator := anObject
]

{ #category : #accessing }
PBCommunicationHandlerOLD class >> pythonPortGenerator [
	^ PythonPortGenerator
]

{ #category : #accessing }
PBCommunicationHandlerOLD class >> pythonPortGenerator: anObject [
	PythonPortGenerator := anObject
]

{ #category : #adding }
PBCommunicationHandlerOLD >> addRoute: aPath block: aBlock [
	routes add: (aPath -> aBlock)
]

{ #category : #converting }
PBCommunicationHandlerOLD >> decode: req [
	^ NeoJSONReader fromString: req contents
]

{ #category : #initialization }
PBCommunicationHandlerOLD >> initialize [
	super initialize.
	pharoPort := self class pharoPortGenerator value.
	pythonPort := self class pythonPortGenerator value.
	routes := OrderedCollection new
]

{ #category : #initialization }
PBCommunicationHandlerOLD >> initializeHandler [
	super initializeHandler.
	
]

{ #category : #testing }
PBCommunicationHandlerOLD >> isPythonReady [
	^ [ (ZnEasy get: 'http://localhost:' , self pythonPort asString , '/status') status = 200 ]
		on: Error do: [ :err | false ]
]

{ #category : #accessing }
PBCommunicationHandlerOLD >> pharoPort [
	^ pharoPort
]

{ #category : #accessing }
PBCommunicationHandlerOLD >> pharoPort: anObject [
	pharoPort := anObject
]

{ #category : #accessing }
PBCommunicationHandlerOLD >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: server process 
			ifAbsent: [  ] ]
]

{ #category : #accessing }
PBCommunicationHandlerOLD >> pythonPort [
	^ pythonPort
]

{ #category : #accessing }
PBCommunicationHandlerOLD >> pythonPort: anObject [
	pythonPort := anObject
]

{ #category : #'as yet unclassified' }
PBCommunicationHandlerOLD >> sendPath: path data: data [
	| ans |
	ans := ZnEasy
		post: 'http://localhost:' , self pythonPort asString , path
		data: (ZnEntity text: data).
	ans status = 200 ifFalse: [ Error signal: 'Command rejected by python' ]
]

{ #category : #accessing }
PBCommunicationHandlerOLD >> start [
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
PBCommunicationHandlerOLD >> stop [
	super stop.
	server ifNotNil: [ server stop ]
]
