Class {
	#name : #PBMessageHandlerTest,
	#superclass : #TestCase,
	#category : #'PythonBridge-Platform'
}

{ #category : #tests }
PBMessageHandlerTest >> testAsyncMessage [
	| flag msg handler |
	flag := false.
	msg := PBAsyncMessage new.
	handler := PBMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true ].
	self deny: flag.
	handler handleMessage.
	self deny: handler shouldAnswer.
	self assert: flag.
	self should: [ handler answer ] raise: Error
]

{ #category : #tests }
PBMessageHandlerTest >> testRAsyncMessage [
	| flag msg handler |
	flag := false.
	msg := PBRAsyncMessage new.
	handler := PBMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true ].
	self deny: flag.
	handler handleMessage.
	self deny: handler shouldAnswer.
	self assert: flag.
	self should: [ handler answer ] raise: Error
]

{ #category : #tests }
PBMessageHandlerTest >> testRSyncMessage [
	| flag msg handler ans |
	flag := false.
	ans := nil.
	msg := PBRSyncMessage new.
	handler := PBMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true.
							ans := msg createAnswer ].
	self deny: flag.
	handler handleMessage.
	self assert: handler shouldAnswer.
	self assert: flag.
	self assert: handler answer equals: ans
]

{ #category : #tests }
PBMessageHandlerTest >> testSyncMessage [
	| flag msg handler ans |
	flag := false.
	ans := nil.
	msg := PBSyncMessage new.
	handler := PBMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true.
							ans := msg createAnswer ].
	self deny: flag.
	handler handleMessage.
	self assert: handler shouldAnswer.
	self assert: flag.
	self assert: handler answer equals: ans
]
