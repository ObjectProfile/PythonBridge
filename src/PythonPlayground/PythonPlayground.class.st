Class {
	#name : #PythonPlayground,
	#superclass : #GTPlayground,
	#category : #PythonPlayground
}

{ #category : #accessing }
PythonPlayground >> contextMenuPragma [
	^ #pythonPlaygroundContextMenu
]

{ #category : #accessing }
PythonPlayground >> pageActionPragma [
	^ #pyPageActionOrder:
]

{ #category : #accessing }
PythonPlayground >> playgroundActionPragma [
	^ #pyPlaygroundActionOrder:
]
