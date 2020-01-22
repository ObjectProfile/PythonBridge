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
PBObject class >> fromProxy: aProxy [
	| obj |
	obj := self new.
	obj pythonVariable: aProxy pythonVariable.
	self assert: obj pythonClass asString = aProxy pythonVariable.
	^ obj
]

{ #category : #'instance creation' }
PBObject class >> fromPythonReference: pythonVar [
	^ super new
			pythonVariable: pythonVar;
			yourself.
]

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
	^ self basicCreateObjectExpr: 
			(self pythonConstructor 
				callWith: posArgs 
				with: nameArgs asDictionary)
]

{ #category : #'as yet unclassified' }
PBObject >> basicCreateObjectExpr: anExpression [
	| varName |
	self isCreated ifTrue: [ ^ self ].
	varName := self newPythonVar.
	pythonVariable := varName.
	self application commandFactory << (
		self registerIdPyExpression: anExpression).
	self registerObject.
	self application commandFactory send.
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

{ #category : #accessing }
PBObject >> module [
	^ self applicationClass module
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
PBObject >> pythonConstructor [
	^ self pythonClass
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
