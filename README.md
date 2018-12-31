# PythonBridge
 Bridge between smalltalk and python

# Installation

First, you need to install `PythonBridge` within Pharo (known to work for Pharo 7):
```Smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
``` 

Second, you need to execute the following in a Pharo playground:
`PBApplication ensurePythonHooksFile`
This instruction will write the necessary file in the _folder containing the Pharo image_.

Third and final step, you need to run the following command within a terminal:
`pipenv install`
Not that this command may take a few minutes.


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

The expression given above evaluate the expression `1 + 2` within python, and return the value to Pharo.

# Limitations

- You cannot have two images running at the same time with an open connection to Python. In the future, we will be able to manually set the port.
