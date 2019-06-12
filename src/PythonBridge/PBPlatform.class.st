Class {
	#name : #PBPlatform,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBPlatform class >> current [
	^ Current ifNil: [ Current := self getConcretePlatform ]
]

{ #category : #'as yet unclassified' }
PBPlatform class >> current: aPlatform [
	Current := aPlatform
]

{ #category : #hooks }
PBPlatform class >> defaultSettings [
	^ PBSettings 
		pharoSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: (7000 + 99 atRandom))
		pythonSocketAddress: (PBSocketAddress ipOrName: 'localhost' port: (6900 + 99 atRandom))
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
PBPlatform class >> priority [
	^ -547835385
]
