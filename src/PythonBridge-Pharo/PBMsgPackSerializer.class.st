Class {
	#name : #PBMsgPackSerializer,
	#superclass : #PBAbstractSerializerWrapper,
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #private }
PBMsgPackSerializer >> deserialize: aByteArray [
	^ MpDecoder decode: aByteArray
]

{ #category : #private }
PBMsgPackSerializer >> serialize: anObject [
	^ MpEncoder encode: anObject
]
