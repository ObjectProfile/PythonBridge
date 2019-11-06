Class {
	#name : #PBMsgPackSocketStream,
	#superclass : #Object,
	#instVars : [
		'socketStream',
		'encoder',
		'decoder',
		'decoderSemaphore',
		'encoderSemaphore'
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
	^ decoderSemaphore critical: [ decoder atEnd ]
]

{ #category : #streaming }
PBMsgPackSocketStream >> close [
	| ans |
	ans := socketStream socket ifNotNil: #closeAndDestroy.
	30 timesRepeat: [ encoderSemaphore signal ].
	30 timesRepeat: [ decoderSemaphore signal ].
	^ ans
]

{ #category : #streaming }
PBMsgPackSocketStream >> flush [
	^ socketStream flush
]

{ #category : #initialization }
PBMsgPackSocketStream >> initialize [
	super initialize.
	decoderSemaphore := Semaphore forMutualExclusion.
	encoderSemaphore := Semaphore forMutualExclusion.
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
	^ decoderSemaphore critical: [ decoder next ]
]

{ #category : #streaming }
PBMsgPackSocketStream >> nextPut: anObject [
	| result |
	result := encoderSemaphore critical: [ 
		encoder nextPut: anObject.
		socketStream flush ].
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
		bufferSize: PBMsgPackUtils socketBufferSize;
		timeout: PBMsgPackUtils socketStreamTimeout
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
