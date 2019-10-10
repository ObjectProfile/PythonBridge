Class {
	#name : #PBPharoMessageBrokerTest,
	#superclass : #PBMessageBrokerTest,
	#instVars : [
		'stubServer'
	],
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #utils }
PBPharoMessageBrokerTest >> answer: aDictionary [
	^ aDictionary
]

{ #category : #utils }
PBPharoMessageBrokerTest >> buildAndStartStubServer [
	stubServer := ZnServer on: settings pythonSocketAddress port.
	stubServer start.
	stubServer onRequestRespond: [ :req | self primHandle: req ]
]

{ #category : #utils }
PBPharoMessageBrokerTest >> decodeAnswer: jsonText [
	^ NeoJSONReader fromString: jsonText
]

{ #category : #utils }
PBPharoMessageBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #hooks }
PBPharoMessageBrokerTest >> messageBrokerClass [
	^ PBPharoMessageBroker
]

{ #category : #private }
PBPharoMessageBrokerTest >> primHandle: aRequest [
	| answer |
	answer := [
		handlerBlock value: 
			aRequest uri asString allButFirst 
				-> (NeoJSONReader fromString: aRequest contents)
		] on: Error do: [ :e | 
			handlerException := e.
			^ self errorResponse ].
	answer := [ PBNeoJsonSerializer new serialize: answer ] on: Error do: [ '{}' ].
	^ ZnResponse ok: (ZnEntity json: answer)
]

{ #category : #hooks }
PBPharoMessageBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerEquals: Dictionary new
]

{ #category : #hooks }
PBPharoMessageBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	| ans |
	ans := ZnEasy 
				post: self brokerUri , '/' , (dict at: #type)
				data: (ZnEntity json: (NeoJSONWriter toString: dict)).
	ans status = 200 ifFalse: [ PBCommunicationError signal: ans status asString ].
	aBlock value: (self decodeAnswer: ans contents)
]

{ #category : #running }
PBPharoMessageBrokerTest >> stopStubServer [
	stubServer ifNotNil: [ stubServer stop ]
]
