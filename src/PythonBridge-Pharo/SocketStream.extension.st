Extension { #name : #SocketStream }

{ #category : #'*PythonBridge-Pharo' }
SocketStream >> int32 [
	"Answer the next signed, 32-bit integer from this (binary) stream."
	"Details: As a fast check for negative number, check the high bit of the first digit"

	| n firstDigit |
	n := firstDigit := self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	n := (n bitShift: 8) + self next.
	firstDigit >= 128 ifTrue: [n := -16r100000000 + n].  "decode negative 32-bit integer"
	^ n

]

{ #category : #'*PythonBridge-Pharo' }
SocketStream >> uint16 [
	"Answer the next unsigned, 16-bit integer from this (binary) stream."

	| n |
	n := self next.
	n := (n bitShift: 8) + (self next).
	^ n

]

{ #category : #'*PythonBridge-Pharo' }
SocketStream >> uint16: anInteger [
	"Store the given unsigned, 16-bit integer on this (binary) stream."

	(anInteger < 0 or: [ anInteger >= 16r10000 ])
		ifTrue: [ self error: 'outside unsigned 16-bit integer range' ].
	self nextPut: (anInteger byteAt: 2).
	self nextPut: (anInteger byteAt: 1)
]

{ #category : #'*PythonBridge-Pharo' }
SocketStream >> uint32: anInteger [
	"Store the given unsigned, 32-bit integer on this (binary) stream."

	(anInteger < 0 or: [ anInteger >= 16r100000000 ])
		ifTrue: [self error: 'outside unsigned 32-bit integer range'].

	self nextPut: (anInteger digitAt: 4).
	self nextPut: (anInteger digitAt: 3).
	self nextPut: (anInteger digitAt: 2).
	self nextPut: (anInteger digitAt: 1).

]
