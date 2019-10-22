Class {
	#name : #PBPlatform,
	#superclass : #Object,
	#instVars : [
		'msgBrokerStrategy',
		'processStrategy'
	],
	#classVars : [
		'Current'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBPlatform class >> current [
	^ Current ifNil: [ Current := self getConcretePlatform new ]
]

{ #category : #accessing }
PBPlatform class >> current: aPlatform [
	Current := aPlatform
]

{ #category : #utils }
PBPlatform class >> getConcretePlatform [
	^ (self allSubclasses reject: #isAbstract) 
			inject: nil 
			into: [ :candidate :next |
							candidate 
								ifNil: [ next ]
								ifNotNil: [ 
									candidate priority > next priority
										ifTrue: [ candidate ]
										ifFalse: [ next ] ] ] 
]

{ #category : #hooks }
PBPlatform class >> globalPythonProcessClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> httpMessageBrokerClass [
	self subclassResponsibility
]

{ #category : #testing }
PBPlatform class >> isAbstract [
	^ self name = 'PBPlatform' asSymbol
]

{ #category : #hooks }
PBPlatform class >> manualProcessClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> pipenvProcessClass [
	self subclassResponsibility
]

{ #category : #accessing }
PBPlatform class >> platform [
	^ self current
]

{ #category : #private }
PBPlatform class >> priority [
	^ -547835385
]

{ #category : #hooks }
PBPlatform class >> socketMessageBrokerClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> uiManagerClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> weakRegistryClass [
	self subclassResponsibility
]

{ #category : #'message broker strategy' }
PBPlatform >> defaultMessageBrokerClass [
	^ self class httpMessageBrokerClass
]

{ #category : #utils }
PBPlatform >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: (7000 + 99 atRandom))
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: (6900 + 99 atRandom))
]

{ #category : #hooks }
PBPlatform >> ensureEnvironmentForApp: anApplication [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform >> folderForApplication: application [
	self subclassResponsibility
]

{ #category : #'module creation' }
PBPlatform >> messageBroker: settings [
	^ self messageBrokerStrategy settings: settings
]

{ #category : #'message broker strategy' }
PBPlatform >> messageBrokerStrategy [
	^ msgBrokerStrategy ifNil: [ ^ self defaultMessageBrokerClass ]
]

{ #category : #'message broker strategy' }
PBPlatform >> messageBrokerStrategy: msgBrokerCls [
	msgBrokerStrategy := msgBrokerCls
]

{ #category : #utils }
PBPlatform >> newRandomName [
	self subclassResponsibility
]

{ #category : #'module creation' }
PBPlatform >> process: application [
	^ self processStrategy application: application
]

{ #category : #'process strategy' }
PBPlatform >> processStrategy [
	^ processStrategy ifNil: [ ^ self class pipenvProcessClass ]
]

{ #category : #'process strategy' }
PBPlatform >> processStrategy: processCls [
	processStrategy := processCls
]

{ #category : #'accessing modules' }
PBPlatform >> serializer [
	^ self messageBrokerStrategy serializer
]

{ #category : #'message broker strategy' }
PBPlatform >> setHttpMessageBroker [
	self messageBrokerStrategy: self class httpMessageBrokerClass
]

{ #category : #'process strategy' }
PBPlatform >> setPipenvProcess [
	self processStrategy: self class pipenvProcessClass
]

{ #category : #'message broker strategy' }
PBPlatform >> setSocketMessageBroker [
	self messageBrokerStrategy: self class socketMessageBrokerClass
]

{ #category : #'module creation' }
PBPlatform >> uiManager [
	^ self class uiManagerClass new
]

{ #category : #'module creation' }
PBPlatform >> weakRegistry [
	^ self class weakRegistryClass new
]
