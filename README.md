# PythonBridge
 Bridge that allows executing arbitrary pieces of Python code directly from Pharo.
 
 The official webpage and documentation is https://objectprofile.github.io/PythonBridge/.

# Requirements

This project depends on Python3.6 (or Python3.7) and Pipenv.

# Installation

To install PythonBridge on Pharo just run the following script in a Pharo Playground:
```Smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
``` 
The first part of the script is responsible of downloading the PythonBridge code and loading it in the image.
The second part of the script is responsible of creating a pipenv environment for isolating the python libraries used by the bridge.

Depending on the internet connection, the script could take a couple of minutes to run.

A more in depth guide is present on the official website of this project https://objectprofile.github.io/PythonBridge/.

[Video installation for VisualWorks](https://vimeo.com/401196404)

# Simple test

Evaluating the following code in a playground should return `3`:
```Smalltalk
PBApplication do: [ 
	PBCF << (P3GBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself).
	PBCF send waitForValue
	 ]
```
