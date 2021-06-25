Class {
	#name : #PBSettings,
	#superclass : #Object,
	#instVars : [
		'pharoSocketAddress',
		'pythonSocketAddress',
		'pipenvPath',
		'workingDirectory',
		'serverDebugMode',
		'debugSocketAddress',
		'debugMode'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBSettings class >> pharoSocketAddress: pharoSocketAddress pythonSocketAddress: pythonSocketAddress [
	^ self new
		pharoSocketAddress: pharoSocketAddress;
		pythonSocketAddress: pythonSocketAddress;
		yourself
]

{ #category : #accessing }
PBSettings >> debugMode [
	^ debugMode
]

{ #category : #accessing }
PBSettings >> debugMode: anObject [
	debugMode := anObject
]

{ #category : #accessing }
PBSettings >> debugSocketAddress [
	^ debugSocketAddress
]

{ #category : #accessing }
PBSettings >> debugSocketAddress: anObject [
	debugSocketAddress := anObject
]

{ #category : #ui }
PBSettings >> gtSettingsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Settings';
		priority: 1;
		items: [ self settingNames ];
		column: #Item 
			text: [ :item | item ] 
			width: 170;
		column: #Value 
			text: [ :item | item value: self ]
]

{ #category : #initialization }
PBSettings >> initialize [ 

	super initialize.
	serverDebugMode := false.
	debugMode := false.
]

{ #category : #accessing }
PBSettings >> pharoSocketAddress [
	^ pharoSocketAddress
]

{ #category : #accessing }
PBSettings >> pharoSocketAddress: anObject [
	pharoSocketAddress := anObject
]

{ #category : #accessing }
PBSettings >> pipenvPath [
	^ pipenvPath
]

{ #category : #accessing }
PBSettings >> pipenvPath: aFileReference [

	pipenvPath := aFileReference asFileReference.
	pipenvPath ifNil: [ ^ self ].
	self assert: [ pipenvPath exists ]
		description: pipenvPath fullName, ' doesn''t exist'.
]

{ #category : #accessing }
PBSettings >> pythonSocketAddress [
	^ pythonSocketAddress
]

{ #category : #accessing }
PBSettings >> pythonSocketAddress: anObject [
	pythonSocketAddress := anObject
]

{ #category : #accessing }
PBSettings >> serverDebugMode [
	"Answer a boolean indicating whether the server should be started with the debugger enabled"
	<return: #Boolean>

	^ serverDebugMode
]

{ #category : #accessing }
PBSettings >> serverDebugMode: aBoolean [

	serverDebugMode := aBoolean
]

{ #category : #accessing }
PBSettings >> settingNames [

	^ self class instVarNames sorted
]

{ #category : #accessing }
PBSettings >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PBSettings >> workingDirectory: aFileReference [

	workingDirectory := aFileReference.
]
