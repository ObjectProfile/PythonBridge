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
