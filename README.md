# PythonBridge
 Bridge between smalltalk and python

# Requirements

This project depends on Python3.6 and Pipenv.

To install Python3.6 follow the instructions on the Python webpage https://www.python.org/downloads/release/python-368/. To verify if you have Python3.6 just run in a terminal `python3.6 --version`, it should print something like `Python 3.6.4`.

To install Pipenv just use the following Pip instruction `pip install pipenv`, though depending on your python installation you may need to call it with `sudo`. To verify if you have pipenv just run in a terminal `pipenv --version`, it should print something like `pipenv, version 2018.11.26`. We strongly suggest you to upgrade your pipenv version if it is older that 2018.11.26, because it has important bugfixes and performance improvements. To upgrade it just run `sudo pip install pipenv --upgrade`.

# Instalation

To install PythonBridge on Pharo just run the following script in a Pharo Playground:
```Smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
(Smalltalk at: #PBApplication) installPipenvEnvironment
``` 
The first part of the script is responsible of downloading the PythonBridge code and loading it in the image.
The second part of the script is responsible of creating a pipenv environment for isolating the python libraries used by the bridge.

Depending on the internet connection, the script could take a couple of minutes to run.

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
