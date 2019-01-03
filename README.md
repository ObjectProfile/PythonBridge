# PythonBridge
 Bridge between smalltalk and python

# Instalation

First, you need to install `PythonBridge` within Pharo (known to work for Pharo 7):
```Smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
``` 



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

# Limitations

- You cannot have two images running at the same time with an open connection to Python. In the future, we will be able to manually set the port.
