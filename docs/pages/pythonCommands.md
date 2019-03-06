---
layout: default
permalink: /pages/pythonCommands
title: Building Python Commands
nav_order: 2
---

# Python Commands
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Python Command

The python command is the basic unit of work of PythonBridge. It allows developers to run arbitrary python code from Pharo. It is composed by a sequence of python statements, a collection of variable bindings, pharo observers callbacks and a transformation block.

### Python statements

The python statements are created in Pharo by using [Python3Generator](https://github.com/juliendelplanque/Python3Generator).

#### `<-` Variable assignment
Assignments in python allow you to store objects in globals, temporary variables and instance variables. Python3Generator uses the message `<-` to assign the value at the right of the message to the receiver.

Assigning the temporary variable `w` with the array `[1,2,3]`.
```smalltalk
w asP3GI <- #(1 2 3)    "w = [1,2,3]"
```

Assigning instance variable `a` from object in variable `foo` with the string `'bar'`.
```smalltalk
(foo asP3GI => #a) <- 'bar'    "foo.a = 'bar'"
```

## Command Factory

Each PythonBridge extension defines its own CommandFactory as a global object. In the case of PythonBridge it's called `PBCF` and in KerasBridge is called `KCF`.

