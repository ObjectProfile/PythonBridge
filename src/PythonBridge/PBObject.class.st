Class {
	#name : #PBObject,
	#superclass : #Object,
	#traits : 'P3GAttributeAccess',
	#classTraits : 'P3GAttributeAccess classTrait',
	#instVars : [
		'pythonVariable'
	],
	#category : #'PythonBridge-Core'
}

{ #category : #'instance creation' }
PBObject class >> newPythonVar [
	^ ('pb' , UUID new asString36) asP3GIdentifier
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
	self application commandFactory << (
		varName <- (self pythonClass callWith: posArgs with: nameArgs asDictionary)).
	pythonVariable := varName
]

{ #category : #'as yet unclassified' }
PBObject >> basicCreateObjectExpr: anExpression [
	| varName |
	self isCreated ifTrue: [ ^ self ].
	varName := self newPythonVar.
	self application commandFactory << (
		varName <- anExpression).
	pythonVariable := varName
	
]

{ #category : #'as yet unclassified' }
PBObject >> createObject [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
PBObject >> ensureCreateObject [
	self isCreated ifFalse: [ self createObject ]
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

{ #category : #accessing }
PBObject >> pythonVariable [
	^ pythonVariable
]

{ #category : #'as yet unclassified' }
PBObject >> writePython3On: aStream [
	self assert: self isCreated.
	pythonVariable writePython3On: aStream
]
