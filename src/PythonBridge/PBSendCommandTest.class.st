Class {
	#name : #PBSendCommandTest,
	#superclass : #PBApplicationTest,
	#category : #'PythonBridge-Tests'
}

{ #category : #tests }
PBSendCommandTest >> testAddBinding [
	| binding |
	binding := PBBinding wrap: #((2) 3).
	self cf addBinding: binding.
	self cf << binding.
	self assert: self cfSend waitForValue equals: #((2) 3)
]

{ #category : #tests }
PBSendCommandTest >> testAddObserver [
	| observer callbackExecuted promiseSem |
	promiseSem := Semaphore new.
	callbackExecuted := false.
	observer := self cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true ].
	self cf << (observer pythonNotify: 33).
	self cf << 2.
	self cfSend.
	promiseSem signal.
	self assert: promise waitForValue equals: 2.
	self assert: callbackExecuted
]

{ #category : #tests }
PBSendCommandTest >> testCallbackReturnValue [
	| observer callbackExecuted promiseSem |
	promiseSem := Semaphore new.
	callbackExecuted := false.
	observer := self cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true.
		5 ].
	self cf << (observer pythonNotify: 33).
	self cfSend.
	promiseSem signal.
	self assert: promise waitForValue equals: 5.
	self assert: callbackExecuted
]

{ #category : #tests }
PBSendCommandTest >> testInvalidCallbackReturn [
	| observer callbackExecuted promiseSem |
	promiseSem := Semaphore new.
	callbackExecuted := false.
	observer := self cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true.
		self ].
	self cf << (observer pythonNotify: 33).
	self cfSend.
	promiseSem signal.
	self assert: promise waitForValue equals: nil.
	self assert: callbackExecuted
]

{ #category : #tests }
PBSendCommandTest >> testSendAssignAsLastMessage [
	self cf << (#foo asP3GI <- 33).
	self cfSend.
	self assert: promise waitForValue equals: nil
]

{ #category : #tests }
PBSendCommandTest >> testSendImportAsLastMessage [
	self cf << #sys asP3GI import.
	self cfSend.
	self assert: promise waitForValue equals: nil
]
