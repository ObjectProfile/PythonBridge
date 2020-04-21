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

#### Attribute accessing
Python objects instance variables and methods are accessible in Python by operator `.`. From Pharo, this operator is defined using `=>` and allow accessing instance variables and invoking methods.
```smalltalk
#foo asP3GI => #a    "foo.a"
```

#### Method and function invoking
Python functions and methods are called by using `callWith:` and `callWith:with:`. 

The `callWith:` method receive as argument a collection of objects which corresponds to the positional arguments of the call.
```smalltalk
#foo asP3GI callWith: #(1 2 3)    "foo(1,2,3)"
```

The `callWith:with:` method receives as first agument a collection of positional arguments and, as second argument, a dictionary of named arguments.
```smalltalk
#foo asP3GI 
    callWith: #(1 2 3) 
    with: { 
        #nameArg1 -> 'bar'.
        #nameArg2 -> 5 } asDictionary

"foo(1, 2, 3, nameArg1='bar', nameArg2=5)"
```

#### Variable assignment
Assignments in python allow you to store objects in globals, temporary variables and instance variables. Python3Generator uses the message `<-` to assign the value at the right of the message to the receiver.

Assigning the temporary variable `w` with the array `[1,2,3]`.
```smalltalk
#foo asP3GI <- #(1 2 3)    "foo = [1,2,3]"
```

Assigning instance variable `a` from object in variable `foo` with the string `'bar'`.
```smalltalk
(#foo asP3GI => #a) <- 'bar'    "foo.a = 'bar'"
```


## Importing an External Module

PythonBridge can interact with any python modules. Consider the `numpy` Python module, which essential in scientific computing. We will perform the following Python instruction within Smalltalk: `numpy.arange(15).reshape(3, 5)`

First, we need to augment the Pipenv environment with the `numpy` module. You can simply do it by modifying the `Pipfile` by adding the line `numpy = "*"`. The complete `Pipfile` should be:

```
[[source]]
name = "pypi"
url = "https://pypi.org/simple"
verify_ssl = true

[dev-packages]

[packages]
flask = "*"
requests = "*"
msgpack = "*"
numpy = "*"

[requires]
python_version = "3"
```

Once the `Pipfile` file modified, the pipenv environment must be upgraded, which can be done using the command line:
```
pipenv update
```

You should see something like: 
```
➜  PythonBridge git:(master) ✗ pipenv update
Running $ pipenv lock then $ pipenv sync.
Locking [dev-packages] dependencies…
Locking [packages] dependencies…
✔ Success! 
Updated Pipfile.lock (deca6d)!
Installing dependencies from Pipfile.lock (deca6d)…
  🐍   ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉ 14/14 — 00:00:07
To activate this project's virtualenv, run pipenv shell.
Alternatively, run a command inside the virtualenv with pipenv run.
All dependencies are now up-to-date!
```

Numpy is now installed in your Pipenv environment, and it is ready to be used from Smalltalk. You can do 

```Smalltalk
PBApplication do: [ 
    "We import the numpy module"
	PBCF << (P3GImport moduleIdentifier: #numpy asP3GI).
    
    "We construct the Python expression numpy.arange(15).reshape(3, 5)"
	r := P3GCall target: (#numpy asP3GI => #arange) positionalArguments: #(15).
	PBCF << (P3GCall target: r => #reshape positionalArguments: #(3 5)). 
	s := PBCF send waitForValue.
    
    "The variable s points to a Smalltalk wrapper of the Python object"
    "We simply execute the Python expression str(s) to obtain a string that represents the numpy object"
	PBCF << (P3GCall target: #str asP3GI positionalArguments: (Array with: s )). 
	PBCF send waitForValue.
	 ].
```

Printing this expression will result in:
```Python
[[ 0  1  2  3  4]
 [ 5  6  7  8  9]
 [10 11 12 13 14]]
```

This small example shows how you can augment the Pipenv environment with a new Python module, and how you can access it from Smalltalk.

## Command Factory

Each PythonBridge extension defines its own CommandFactory as a global object. In the case of PythonBridge it's called `PBCF` and in KerasBridge is called `KCF`.

