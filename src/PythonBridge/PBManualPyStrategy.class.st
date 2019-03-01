Class {
	#name : #PBManualPyStrategy,
	#superclass : #PBPyProcessStrategy,
	#category : #'PythonBridge-Core'
}

{ #category : #'as yet unclassified' }
PBManualPyStrategy class >> prepare [
	PBCommunicationHandler pythonPortGenerator: [ 7100 ].
	PBCommunicationHandler pharoPortGenerator: [ 7200 ]
]

{ #category : #accessing }
PBManualPyStrategy >> isRunning [
	^ true
]

{ #category : #accessing }
PBManualPyStrategy >> start [
	
]

{ #category : #accessing }
PBManualPyStrategy >> stop [
]
