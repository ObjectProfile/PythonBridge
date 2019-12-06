Class {
	#name : #PBPython3GenerationTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Tests'
}

{ #category : #'as yet unclassified' }
PBPython3GenerationTest >> getPythonCode: aPythonExpression [
	^ self getPythonCodeUsingStream: [ :str | aPythonExpression writePython3On: str ]
]

{ #category : #'as yet unclassified' }
PBPython3GenerationTest >> getPythonCodeUsingStream: aBlock [
	| stream |
	stream := String new writeStream.
	aBlock value: stream.
	^ stream contents
]

{ #category : #tests }
PBPython3GenerationTest >> testBinding [
	| binding |
	binding := PBBinding wrap: 32.
	self 
		assert: (self getPythonCode: binding) 
		equals: binding key
]

{ #category : #tests }
PBPython3GenerationTest >> testObserverNotify [
	| obs |
	obs := PBObserver callback: [ 32 ].
	obs command: PBCommand new.
	self 
		assert: (self getPythonCode: (obs pythonNotify: 'foobar')) 
		equals: 'observer(''' , obs command id , ''',''' , obs id , ''')(''foobar'')'
]
