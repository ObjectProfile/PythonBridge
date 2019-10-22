Class {
	#name : #PBHttpMessageBrokerTest,
	#superclass : #PBMessageBrokerTest,
	#instVars : [
		'stubServer'
	],
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #utils }
PBHttpMessageBrokerTest >> answer: aDictionary [
	^ aDictionary
]

{ #category : #utils }
PBHttpMessageBrokerTest >> buildAndStartStubServer [
	stubServer := ZnServer on: settings pythonSocketAddress port.
	stubServer start.
	stubServer onRequestRespond: [ :req | self primHandle: req ]
]

{ #category : #utils }
PBHttpMessageBrokerTest >> decodeAnswer: jsonText [
	^ NeoJSONReader fromString: jsonText
]

{ #category : #utils }
PBHttpMessageBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #hooks }
PBHttpMessageBrokerTest >> messageBrokerClass [
	^ PBHttpMessageBroker
]

{ #category : #private }
PBHttpMessageBrokerTest >> primHandle: aRequest [
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
PBHttpMessageBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerEquals: Dictionary new
]

{ #category : #hooks }
PBHttpMessageBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	| ans |
	ans := ZnEasy 
				post: self brokerUri , '/' , (dict at: #type)
				data: (ZnEntity json: (NeoJSONWriter toString: dict)).
	ans status = 200 ifFalse: [ PBCommunicationError signal: ans status asString ].
	aBlock value: (self decodeAnswer: ans contents)
]

{ #category : #utils }
PBHttpMessageBrokerTest >> sleepAWhile [
	"With HTTP there is no need to sleep."
]

{ #category : #running }
PBHttpMessageBrokerTest >> stopStubServer [
	stubServer ifNotNil: [ stubServer stop ]
]
