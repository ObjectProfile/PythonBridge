"
PBCommandStringFactory is variant of the command factory that takes two strings to build the set of statements:

- script: a python script that will be evaluated on the remote.
- resultExpression: a single python expression whose value will be returned.

Note that PBCommandStringFactory no longer uses the instructions instance variable from ${class:name=PBCommandFactory}$.

Example usage:

[[[ 
self application newCommandStringFactory
	script: 
'a = 4
b = 3';
	resultExpression: 'a + b';
	sendAndWait
]]]
"
Class {
	#name : #PBCommandStringFactory,
	#superclass : #PBCommandFactory,
	#instVars : [
		'script',
		'resultExpression'
	],
	#category : #'PythonBridge-Execution'
}

{ #category : #streaming }
PBCommandStringFactory >> << anObject [

	self error: 'PBCommandStringFactory expects a single python script'
]

{ #category : #api }
PBCommandStringFactory >> addAllBindings: aDictionary [
	"Add the supplied key / value pairs as bindings to the receiver"

	aDictionary keysAndValuesDo: [ :key :value |
		self bindingAt: key put: value ]
]

{ #category : #streaming }
PBCommandStringFactory >> append: aPythonStatement [

	self error: 'PBCommandStringFactory expects a single python script'
]

{ #category : #accessing }
PBCommandStringFactory >> instructionsWithNotifyAtEnd [

	^ String streamContents: [ :stream |
		stream 
			<< script withUnixLineEndings;
			lf;
			<< 'notify(';
			<< resultExpression;
			<< ', ';
			print: command id;
			<< ')' ].

]

{ #category : #initialization }
PBCommandStringFactory >> reset [
	script := ''.
	resultExpression := #None.
	bindingsDictionary := Dictionary new.
	observers := OrderedCollection new.
	command := PBCommandString new.
	transformBlock := #yourself
]

{ #category : #accessing }
PBCommandStringFactory >> resultExpression [
	<return: #String>

	^ resultExpression
]

{ #category : #accessing }
PBCommandStringFactory >> resultExpression: aString [

	resultExpression := aString
]

{ #category : #accessing }
PBCommandStringFactory >> script [
	<return: #String>

	^ script
]

{ #category : #accessing }
PBCommandStringFactory >> script: aString [
	"Set the Python script to be executed on the remote"

	script := aString
]
