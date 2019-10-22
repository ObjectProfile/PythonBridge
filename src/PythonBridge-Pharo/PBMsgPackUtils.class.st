Class {
	#name : #PBMsgPackUtils,
	#superclass : #Object,
	#category : #'PythonBridge-Pharo-MessageBroker'
}

{ #category : #constants }
PBMsgPackUtils class >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : #'socket creation' }
PBMsgPackUtils class >> openConnectionToHost: address port: port [
	| stream |
	stream := SocketStream openConnectionToHost: address port: port.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #'socket creation' }
PBMsgPackUtils class >> primStreamFromSocket: aSocket [
	| stream |
	stream := SocketStream on: aSocket.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #private }
PBMsgPackUtils class >> setReferenceSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: true;
		bufferSize: PBMsgPackUtils socketBufferSize;
		timeout: PBMsgPackUtils socketStreamTimeout
]

{ #category : #constants }
PBMsgPackUtils class >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #constants }
PBMsgPackUtils class >> socketStreamTimeout [
	"Slightly less than a year. In other words, this socket doesn't timeout"
	^ 30000000
]
