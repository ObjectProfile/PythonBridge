Class {
	#name : #PBPlatform,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #accessing }
PBPlatform class >> current [
	^ Current ifNil: [ Current := self getConcretePlatform ]
]

{ #category : #accessing }
PBPlatform class >> current: aPlatform [
	Current := aPlatform
]

{ #category : #hooks }
PBPlatform class >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: (7000 + 99 atRandom))
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: (6900 + 99 atRandom))
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
PBPlatform class >> jsonSerializerClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> messageBrokerClass [
	self subclassResponsibility
]

{ #category : #private }
PBPlatform class >> priority [
	^ -547835385
]

{ #category : #hooks }
PBPlatform class >> processClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> uiManager [
	^ self uiManagerClass new
]

{ #category : #private }
PBPlatform class >> uiManagerClass [
	self subclassResponsibility
]

{ #category : #hooks }
PBPlatform class >> weakRegistry [
	^ self weakRegistryClass new
]

{ #category : #hooks }
PBPlatform class >> weakRegistryClass [
	self subclassResponsibility
]
