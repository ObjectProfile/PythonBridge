Class {
	#name : #PBCommandStringTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBCommandStringTest >> testNewCommandHasEmtptyBindings [
	| command |
	command := PBCommandString new.
	self assert: command id isString.
	self assert: command id notEmpty.
	self assert: command bindings equals: #().
]

{ #category : #tests }
PBCommandStringTest >> testNotValidBindingsKeyNotString [
	| command |
	command := PBCommandString new.
	command bindings: { 33 -> 'bar' }.
	self deny: command isValid
]

{ #category : #tests }
PBCommandStringTest >> testNotValidBindingsNotAssoc [
	| command |
	command := PBCommandString new.
	command bindings: { '33' -> 'bar'. 'foo' }.
	self deny: command isValid
]
