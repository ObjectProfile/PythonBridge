"
PBUnixSubprocess is a convenience wrapper around OSSUnixSubprocess for the common case of executing a command and capturing stdout and stderr, which are strings and are larger than one OS buffer, but small enough to fit in RAM.

Typical usage is: 

``` 
proc := (PBUnixSubprocess command: 'ls' arguments: #('-lh'))
proc errorBlock: [ :proc | self error: 'External process failed, see proc' ].
proc runAndWait
proc stdout
```

If no error block is supplied the completion status should be checked with `#isSuccess`.


Public API and Key Messages

- command:arguments: 	(class) create an instance with the supplied parameters
- errorBlock: 			Set the block to be evaluated if the process exits unsuccessfully.
		Note that this is only called if the process is successfully started and subsequently fails.
		Supplying a non-existing path, or a command that can't be found, will raise an error in the calling process.
- removeLD_LIBRARY_PATH: 	Remove LD_LIBRARY_PATH from the environment passed to the subprocess.
		This is useful on linux if the command expects the system installation of openssl.
- runAndWait: 			Execute the command and wait for completion.
- isSuccess 				Answer a boolean indicating if the command completed successfully.
- stdout, stderr: 		The output strings.

 
## Internal Representation and Key Implementation Points.


### Instance Variables

	arguments:		<Array>
	command:			<String>
	errorBlock:		<BlockClosure>
	process:			<OSSUnixSubprocess>
	semaphore:		<Semaphore>
	stderrStream:	<WriteStream on: String>
	stdoutStream:	<WriteStream on: String>


### Implementation Points


"
Class {
	#name : #PBUnixSubprocess,
	#superclass : #Object,
	#instVars : [
		'command',
		'arguments',
		'shellCommand',
		'process',
		'semaphore',
		'errorBlock',
		'workingDirectory',
		'stdoutStream',
		'stderrStream'
	],
	#category : #'PythonBridge-Pharo-Processes'
}

{ #category : #'instance creation' }
PBUnixSubprocess class >> command: cmd arguments: args [

	^self new
		command: cmd;
		arguments: args.
]

{ #category : #adding }
PBUnixSubprocess >> addAllEnvVariablesFromParentWithoutOverride [

	self process addAllEnvVariablesFromParentWithoutOverride
]

{ #category : #accessing }
PBUnixSubprocess >> arguments [
	^ arguments
]

{ #category : #accessing }
PBUnixSubprocess >> arguments: anObject [
	arguments := anObject
]

{ #category : #cleaning }
PBUnixSubprocess >> closeAndCleanStreams [

	process ifNil: [ ^ self ].
	process closeAndCleanStreams.
]

{ #category : #accessing }
PBUnixSubprocess >> command [
	^ command
]

{ #category : #accessing }
PBUnixSubprocess >> command: anObject [
	command := anObject
]

{ #category : #'env building' }
PBUnixSubprocess >> envVariables [

	^ process envVariables
]

{ #category : #accessing }
PBUnixSubprocess >> environmentAt: key put: value [

	^ self process environmentAt: key put: value
]

{ #category : #accessing }
PBUnixSubprocess >> errorBlock [
	^ errorBlock
]

{ #category : #accessing }
PBUnixSubprocess >> errorBlock: anObject [
	errorBlock := anObject
]

{ #category : #accessing }
PBUnixSubprocess >> exitCode [ 
	"Answer the interpretted exit status, or nil if not available"

	(process isNil or: [ process isRunning ]) ifTrue: [ ^ nil ].
	^ process exitStatusInterpreter exitStatus
]

{ #category : #accessing }
PBUnixSubprocess >> exitStatus [ 

	^ process exitStatus
]

{ #category : #status }
PBUnixSubprocess >> exitStatusInterpreter [

	^ process exitStatusInterpreter
]

{ #category : #testing }
PBUnixSubprocess >> hasProcess [
	"Answer a boolean indicating whether the receiver has a process object"

	^ process isNotNil
]

{ #category : #initialization }
PBUnixSubprocess >> initialize [

	super initialize.
	arguments := #().
]

{ #category : #testing }
PBUnixSubprocess >> isRunning [ 

	^ self process isRunning
]

{ #category : #accessing }
PBUnixSubprocess >> isSuccess [
	"Answer whether the command completed successfully.
	Only valid after the command has completed."
	
	^process exitStatusInterpreter isSuccess
]

{ #category : #printing }
PBUnixSubprocess >> printOn: aStream [

	process ifNil: [ ^super printOn: aStream ].
	process isRunning ifTrue:
		[ aStream nextPutAll: 'a Running GtUnixSubprocess' ]
	ifFalse:
		[ self isSuccess ifTrue: 
				[ aStream nextPutAll: 'a Successfull GtUnixSubprocess' ]
			ifFalse:
				[ aStream nextPutAll: 'an Unsuccessfull GtUnixSubprocess' ] ].
]

{ #category : #accessing }
PBUnixSubprocess >> process [

	^ process ifNil: [ process := OSSUnixSubprocess new ]
]

{ #category : #status }
PBUnixSubprocess >> queryExitStatus [

	^ process queryExitStatus
]

{ #category : #removing }
PBUnixSubprocess >> removeLD_LIBRARY_PATH [
	"The script for running pharo sets LD_LIBRARY_PATH to the VM directory, which contains non-standard libraries.
	Unset LD_LIBRARY_PATH."

	self process addAllEnvVariablesFromParentWithoutOverride.
	self process envVariables removeKey: 'LD_LIBRARY_PATH'.
]

{ #category : #running }
PBUnixSubprocess >> run [
	"Run the command without waiting"

	semaphore := nil.
	^self runProcess
]

{ #category : #running }
PBUnixSubprocess >> runAndWait [
	"Run the command and wait for completion"

	semaphore := Semaphore new.
	self runProcess.
	semaphore wait.
	(errorBlock isNotNil and: [ self isSuccess not ])
		ifTrue: [ errorBlock value: self ]
]

{ #category : #private }
PBUnixSubprocess >> runProcess [
	"Run the requested command as a separate process"

	self setCommand.
	stdoutStream := String new writeStream.
	stderrStream := String new writeStream.
	self process
		redirectStdout;
		redirectStderr.
	workingDirectory ifNotNil: 
		[ self process workingDirectory: workingDirectory fullName ].
	self process run.

	[ self process
		waitForExitPollingEvery: (Delay forMilliseconds: 500)
		doing: [ :proc :outStream :errStream | 
			stdoutStream nextPutAll: outStream upToEnd.
			stderrStream nextPutAll: errStream upToEnd ].
	self process closeAndCleanStreams.
	"Async processes have errors signalled here.
	If waiting, raise the error after signalling the semaphore (in #runAndWait)"
	semaphore
		ifNil: [ (errorBlock isNotNil and: [ self isSuccess not ])
				ifTrue: [ errorBlock value: self ] ]
		ifNotNil: [ semaphore signal ] ] fork.

]

{ #category : #private }
PBUnixSubprocess >> setCommand [
	"Set the command or shell command in the process.
	Either may be specified, but not both :-)"

	(command isNil and: [ shellCommand isNil ]) ifTrue: 
		[ self error: 'No command supplied' ].
	(command isNotNil and: [ shellCommand isNotNil ]) ifTrue: 
		[ self error: 'Only one of a command or shell command may be supplied' ].

	command ifNil: 
		[ self process shellCommand: shellCommand ]
	ifNotNil:
		[ self process
			command: command;
			arguments: arguments ].

]

{ #category : #accessing }
PBUnixSubprocess >> shellCommand [
	^ shellCommand
]

{ #category : #accessing }
PBUnixSubprocess >> shellCommand: anObject [
	shellCommand := anObject
]

{ #category : #'OS signal sending' }
PBUnixSubprocess >> sigterm [
	"Ask the external process to terminate"

	^process sigterm
]

{ #category : #accessing }
PBUnixSubprocess >> stderr [
	^ stderrStream contents
]

{ #category : #accessing }
PBUnixSubprocess >> stdout [
	^ stdoutStream contents
]

{ #category : #actions }
PBUnixSubprocess >> terminate [

	process terminate
]

{ #category : #'system startup & shutdown' }
PBUnixSubprocess >> terminateOnShutdown [

	self process terminateOnShutdown
]

{ #category : #accessing }
PBUnixSubprocess >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
PBUnixSubprocess >> workingDirectory: aFileReference [

	workingDirectory := aFileReference asFileReference
]
