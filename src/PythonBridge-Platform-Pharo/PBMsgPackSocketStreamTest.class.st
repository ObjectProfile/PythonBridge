Class {
	#name : #PBMsgPackSocketStreamTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #private }
PBMsgPackSocketStreamTest >> assertSerialize: anObject [
	self connectStreams: [ :serverStream :clientStream |
		clientStream nextPut: anObject.
		self assert: serverStream next equals: anObject.
		self deny: serverStream atEnd ]
]

{ #category : #private }
PBMsgPackSocketStreamTest >> connectStreams: aBlock [
	| semaphore clientSocket serverStream clientStream |
	self serverSocket: [ :serverSocket |
		semaphore := Semaphore new.
		[ 	clientSocket := serverSocket waitForAcceptFor: 10.
			semaphore signal. ] forkAt: self serverPriority.
		[	clientStream := self openConnectionToHost: #[ 127 0 0 1 ] port: self port.
			semaphore wait.
			[	serverStream := SocketStream on: clientSocket.
				aBlock 
					value: (PBMsgPackSocketStream on: serverStream) 
					value: (PBMsgPackSocketStream on: clientStream)
				 ]
			ensure: [ serverStream close ] ]
		ensure: [ clientStream close ]. ]
]

{ #category : #private }
PBMsgPackSocketStreamTest >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : #private }
PBMsgPackSocketStreamTest >> openConnectionToHost: host port: port [
	| stream |
	stream := SocketStream openConnectionToHost: host port: port.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #private }
PBMsgPackSocketStreamTest >> port [
	^ 1332
]

{ #category : #private }
PBMsgPackSocketStreamTest >> referenceSocketStreamOn: socket [
	| stream |
	stream := SocketStream on: socket.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #private }
PBMsgPackSocketStreamTest >> serverPriority [
	^ Processor userBackgroundPriority
]

{ #category : #private }
PBMsgPackSocketStreamTest >> serverSocket: aBlock [
	| serverSocket |
	[	serverSocket := self serverSocketOn: self port.
		self assert: serverSocket notNil.
		self assert: serverSocket localPort equals: self port.
		aBlock value: serverSocket]
	ensure: [ 
			serverSocket closeAndDestroy ]
]

{ #category : #private }
PBMsgPackSocketStreamTest >> serverSocketOn: port [
	| socket |
	(socket := Socket newTCP)
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: self socketBufferSize;
		setOption: 'SO_RCVBUF' value: self socketBufferSize .
	socket listenOn: port backlogSize: self listenBacklogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : #private }
PBMsgPackSocketStreamTest >> setReferenceSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self socketBufferSize;
		timeout: self socketStreamTimeout
]

{ #category : #private }
PBMsgPackSocketStreamTest >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
PBMsgPackSocketStreamTest >> socketStreamTimeout [
	^ 30
]

{ #category : #private }
PBMsgPackSocketStreamTest >> testAssertError [
	self should: [ self connectStreams: [ :serverStream :clientStream | 
			Error signal ] ] raise: Error.
]

{ #category : #private }
PBMsgPackSocketStreamTest >> testBidirectionality [
	self connectStreams: [ :serverStream :clientStream |
		serverStream nextPut: 'Foo'.
		clientStream nextPut: true.
		self assert: serverStream next equals: true.
		self assert: clientStream next equals: 'Foo' ]
]

{ #category : #private }
PBMsgPackSocketStreamTest >> testByteArray [
	self assertSerialize: #[ 1 23 54 ]
]

{ #category : #private }
PBMsgPackSocketStreamTest >> testConnect [
	self connectStreams: [ :serverStream :clientStream | ]
]

{ #category : #private }
PBMsgPackSocketStreamTest >> testInteger [
	self assertSerialize: 3
]

{ #category : #private }
PBMsgPackSocketStreamTest >> testString [
	self assertSerialize: 'FooBarZork'
]
