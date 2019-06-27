Class {
	#name : #PBObject,
	#superclass : #Object,
	#traits : 'P3GAttributeAccess + P3GCallable',
	#classTraits : 'P3GAttributeAccess classTrait + P3GCallable classTrait',
	#instVars : [
		'pythonVariable'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'instance creation' }
PBObject class >> newPythonVar [
	^ PBPlatform current newRandomName asP3GIdentifier
]

{ #category : #initialization }
PBObject >> application [
	^ self applicationClass uniqueInstance
]

{ #category : #initialization }
PBObject >> applicationClass [
	self class == PBObject ifTrue: [ ^ PBApplication ].
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PBObject >> basicCreateObject [
	self basicCreateObjectArgs: #()
]

{ #category : #'as yet unclassified' }
PBObject >> basicCreateObjectArgs: posArgs [
	self basicCreateObjectArgs: posArgs nameArgs: Dictionary new
]

{ #category : #'as yet unclassified' }
PBObject >> basicCreateObjectArgs: posArgs nameArgs: nameArgs [
	| varName |
	self isCreated ifTrue: [ ^ self ].
	varName := self newPythonVar.
	pythonVariable := varName.
	self application commandFactory << (
		self registerIdPyExpression: (self pythonClass callWith: posArgs with: nameArgs asDictionary)).
	self registerObject
]

{ #category : #'as yet unclassified' }
PBObject >> basicCreateObjectExpr: anExpression [
	| varName |
	self isCreated ifTrue: [ ^ self ].
	varName := self newPythonVar.
	pythonVariable := varName.
	self application commandFactory << (
		self registerIdPyExpression: anExpression).
	self registerObject
	
]

{ #category : #'as yet unclassified' }
PBObject >> createObject [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PBObject >> ensureCreateObject [
	self isCreated ifFalse: [ self createObject ]
]

{ #category : #accessing }
PBObject >> id [
	^ pythonVariable name
]

{ #category : #'as yet unclassified' }
PBObject >> isCreated [
	^ pythonVariable notNil
]

{ #category : #p3generator }
PBObject >> isPythonGenerable [
	^ true
]

{ #category : #p3generator }
PBObject >> isPythonValue [
	^ true
]

{ #category : #'instance creation' }
PBObject >> newPythonVar [
	^ self class newPythonVar
]

{ #category : #'as yet unclassified' }
PBObject >> pythonClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PBObject >> pythonClassName [
	^ self pythonClass attributeIdentifier name
]

{ #category : #'as yet unclassified' }
PBObject >> pythonRegistryExpression [
	^ #registry callWith: #()
]

{ #category : #accessing }
PBObject >> pythonVariable [
	^ pythonVariable
]

{ #category : #'as yet unclassified' }
PBObject >> registerIdPyExpression: objExpr [
	^ self pythonRegistryExpression => #register_with_id callWith: (Array with: objExpr with: self id)
]

{ #category : #'as yet unclassified' }
PBObject >> registerObject [
	self application registerObject: self
]

{ #category : #'as yet unclassified' }
PBObject >> resolveIdPyExpression [
	^ self pythonRegistryExpression => #resolve callWith: (Array with: self id)
]

{ #category : #'as yet unclassified' }
PBObject >> writePython3On: aStream [
	self assert: self isCreated.
	self resolveIdPyExpression writePython3On: aStream
]
