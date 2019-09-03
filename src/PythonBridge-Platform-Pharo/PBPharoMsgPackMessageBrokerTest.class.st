Class {
	#name : #PBPharoMsgPackMessageBrokerTest,
	#superclass : #PBMessageBrokerTest,
	#category : #'PythonBridge-Platform-Pharo'
}

{ #category : #hooks }
PBPharoMsgPackMessageBrokerTest >> buildAndStartStubServer [
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : #hooks }
PBPharoMsgPackMessageBrokerTest >> messageBrokerClass [
	^ PBPharoMsgPackPharoBroker
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> openConnectionToHost: host port: port [
	| stream |
	stream := SocketStream openConnectionToHost: host port: port.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> port [
	^ 1733
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> referenceSocketStreamOn: socket [
	| stream |
	stream := SocketStream on: socket.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> runServer: block [
	| serverSocket semaphore |
	serverSocket := self serverSocketOn: self port.
	self assert: serverSocket notNil.
	self assert: serverSocket localPort equals: self port.
	semaphore := Semaphore new.
	[ 
	semaphore signal.
	[ block cull: serverSocket cull: semaphore ]
		ensure: [ 
			serverSocket closeAndDestroy.
			semaphore signal ] ] forkAt: self serverPriority.
	semaphore wait.
	^ semaphore
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> serverPriority [
	^ Processor userBackgroundPriority
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> serverSocketOn: port [
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
PBPharoMsgPackMessageBrokerTest >> setReferenceSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: self socketBufferSize;
		timeout: self socketStreamTimeout
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> socketStreamTimeout [
	^ 30
]

{ #category : #hooks }
PBPharoMsgPackMessageBrokerTest >> stopStubServer [
	
]

{ #category : #private }
PBPharoMsgPackMessageBrokerTest >> testPlain [
	| dataSent dataRead clientStream semaphore |
	dataSent := #[ 6 5 4 3 2 1 ].
	semaphore := self runServer: [ :serverSocket :mySemaphore | | clientSocket serverStream |
		clientSocket := serverSocket waitForAcceptFor: 10.
		serverStream := self referenceSocketStreamOn: clientSocket.
		serverStream nextPutAll: dataSent.
		serverStream close.
		mySemaphore signal ].
	clientStream := self openConnectionToHost: #[ 127 0 0 1 ] port: self port.
	dataRead := clientStream upToEnd.
	clientStream close.
	semaphore wait.
	self assert: dataSent equals: dataRead.
	semaphore wait
]
