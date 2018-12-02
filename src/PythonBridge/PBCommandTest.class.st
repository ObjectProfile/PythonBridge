Class {
	#name : #PBCommandTest,
	#superclass : #TestCase,
	#category : #PythonBridge
}

{ #category : #tests }
PBCommandTest >> testNewCommandHasEmtptyBindings [
	| command |
	command := PBCommand new.
	self assert: command id isString.
	self assert: command id notEmpty.
	self assert: command bindings equals: #().
]

{ #category : #tests }
PBCommandTest >> testNotValidBindingsKeyNotString [
	| command |
	command := PBCommand new.
	command bindings: { 33 -> 'bar' }.
	self deny: command isValid
]

{ #category : #tests }
PBCommandTest >> testNotValidBindingsNotAssociation [
	| command |
	command := PBCommand new.
	command bindings: { 'foo' -> 'bar'. 'zork' }.
	self deny: command isValid
]
