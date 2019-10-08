Class {
	#name : #PBMsgPackSocketStream,
	#superclass : #Object,
	#instVars : [
		'socketStream',
		'encoder',
		'decoder'
	],
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #'instance creation' }
PBMsgPackSocketStream class >> on: socketStream [
	^ self new
		on: socketStream;
		yourself
]

{ #category : #streaming }
PBMsgPackSocketStream >> atEnd [
	^ decoder atEnd
]

{ #category : #streaming }
PBMsgPackSocketStream >> close [
	^ socketStream close
]

{ #category : #streaming }
PBMsgPackSocketStream >> flush [
	^ socketStream flush
]

{ #category : #streaming }
PBMsgPackSocketStream >> isConnected [
	^ socketStream isConnected
]

{ #category : #streaming }
PBMsgPackSocketStream >> isStream [
	^true
]

{ #category : #streaming }
PBMsgPackSocketStream >> next [
	^ decoder next
]

{ #category : #streaming }
PBMsgPackSocketStream >> nextPut: anObject [
	| result |
	result := encoder nextPut: anObject.
	socketStream flush.
	^ result
]

{ #category : #'instance creation' }
PBMsgPackSocketStream >> on: aSocketStream [
	socketStream := aSocketStream.
	self setSocketStreamOptions: socketStream.
	encoder := MpEncoder on: socketStream.
	decoder := MpDecoder on: socketStream
]

{ #category : #private }
PBMsgPackSocketStream >> setSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self socketBufferSize;
		timeout: self socketStreamTimeout
]

{ #category : #private }
PBMsgPackSocketStream >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
PBMsgPackSocketStream >> socketStreamTimeout [
	^ 30
]
