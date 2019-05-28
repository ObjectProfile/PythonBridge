Class {
	#name : #PBPharoMessageBrokerTest,
	#superclass : #TestCase,
	#instVars : [
		'broker',
		'stubServer'
	],
	#category : #'PythonBridge-Pharo-Pipenv'
}

{ #category : #acessing }
PBPharoMessageBrokerTest >> brokerPort [
	^ 6538
]

{ #category : #running }
PBPharoMessageBrokerTest >> buildAndStartStubServer [
	stubServer := ZnServer on: self portTest.
	stubServer start.
	stubServer onRequestRespond: [ :req | self primHandle: req ]
]

{ #category : #acessing }
PBPharoMessageBrokerTest >> portTest [
	^ 6539
]

{ #category : #running }
PBPharoMessageBrokerTest >> setUp [
	super setUp.
	broker := PBPharoMessageBroker
		port: self brokerPort
		pythonUri: 'http://localhost:' , self portTest asString.
	broker start.
	self buildAndStartStubServer
]

{ #category : #running }
PBPharoMessageBrokerTest >> tearDown [
	broker ifNotNil: [ broker stop ].
	stubServer ifNotNil: [ stubServer stop ]
]

{ #category : #tests }
PBPharoMessageBrokerTest >> testIsAliveMessage [
	| flag |
	flag := false.
	self setHandler: [ :assoc | 
		self assert: assoc key equals: PBIsAliveMessage type.
		flag := true ].
	
]

{ #category : #tests }
PBPharoMessageBrokerTest >> testIsRunning [
	self assert: broker isRunning
]
