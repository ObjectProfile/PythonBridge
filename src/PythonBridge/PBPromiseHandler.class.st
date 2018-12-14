Class {
	#name : #PBPromiseHandler,
	#superclass : #PBHandler,
	#category : #'PythonBridge-Core'
}

{ #category : #'private protocol' }
PBPromiseHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
PBPromiseHandler >> initializeHandler [
	self communicationHandler 
		addRoute: '/notify' 
		block: [ :dict | 
			dict 
				at: #id 
				ifPresent: [ :id |
					self updatePromiseId: id with: (self deserialize: (dict at: #value)) ]
				ifAbsent: [ self application log: 'Notify for missing promise.' ] ]
]
