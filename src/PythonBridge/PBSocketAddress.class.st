Class {
	#name : #PBSocketAddress,
	#superclass : #Object,
	#instVars : [
		'ipOrName',
		'port'
	],
	#category : #'PythonBridge-Platform'
}

{ #category : #'as yet unclassified' }
PBSocketAddress class >> ipOrName: ipOrName port: aPort [
	^ self new
			ipOrName: ipOrName;
			port: aPort;
			yourself
]

{ #category : #accessing }
PBSocketAddress >> ipOrName [
	^ ipOrName
]

{ #category : #accessing }
PBSocketAddress >> ipOrName: anObject [
	ipOrName := anObject
]

{ #category : #accessing }
PBSocketAddress >> port [
	^ port
]

{ #category : #accessing }
PBSocketAddress >> port: anObject [
	port := anObject
]

{ #category : #printing }
PBSocketAddress >> printAddress [
	^ ipOrName , ':' , port asString
]
