Class {
	#name : #PBRMessageTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Platform-Messages'
}

{ #category : #tests }
PBRMessageTest >> stubDict [
	^ {#type -> #RSTUB .
		#ivar1 -> #foo .
		#ivar2f -> 3 .
		#ivar2r -> #(#bar) .
		#__sync -> 'ab45d3'
		} asDictionary
]

{ #category : #tests }
PBRMessageTest >> testDecodeRMessage [
	| msg |
	msg := PBRStubMessage decodeFrom: self stubDict.
	self assert: msg ivar1 equals: #foo.
	self assert: msg ivar2 equals: #(3 #bar).
	self assert: msg syncId equals: 'ab45d3'
]

{ #category : #tests }
PBRMessageTest >> testEncodeRAnswer [
	| msg ans |
	msg := PBRStubMessage decodeFrom: self stubDict.
	ans := msg createAnswer.
	ans ivar1: #foo.
	ans ivar2: #(3 #bar).
	self assert: ans encode equals: self stubDict
]
