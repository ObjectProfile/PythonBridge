Class {
	#name : #PBPharoMessageBrokerTest,
	#superclass : #PBMessageBrokerTest,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #utils }
PBPharoMessageBrokerTest >> answer [
	^ ZnResponse ok: (ZnEntity text: '{}')
]

{ #category : #utils }
PBPharoMessageBrokerTest >> answer: aDictionary [
	^ ZnResponse ok: (ZnEntity json: (NeoJSONWriter toString: aDictionary))
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
			self errorResponse ].
	(answer isKindOf: ZnResponse) ifFalse: [ answer := self errorResponse ].
	^ answer
]

{ #category : #hooks }
PBPharoMessageBrokerTest >> sendMessageToBroker: dict [
	| ans |
	ans := ZnEasy 
				post: self brokerUri , '/' , (dict at: #type)
				data: (ZnEntity json: (NeoJSONWriter toString: dict)).
	ans status = 200 ifFalse: [ PBCommunicationError signal: ans status asString ].
	^ self decodeAnswer: ans contents
]

{ #category : #running }
PBPharoMessageBrokerTest >> stopStubServer [
	stubServer ifNotNil: [ stubServer stop ]
]
