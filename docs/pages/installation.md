---
layout: default
permalink: /pages/installation
title: Installation
nav_order: 2
---

# Installation
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Dependencies

PythonBridge has two kind of dependencies, the ones that are automatically installed with the ConfigurationOf or BaselineOf and the ones that must be installed manually by the developer before running the ConfigurationOf.

### Manual dependencies
1. Python 3.6 or newer
1. Pipenv
1. Pharo 6.1 or newer

### Python Automatically installed dependencies
1. Flask

### Pharo Automatically installed dependencies
1. Python3Generatoy
1. Zinc
1. NeoJSON
1. OSSubprocess

## Install Python 3.6

### Ubuntu
We suggest using `sudo apt-get install python3.6`, this should avoid most of the problems.

### OSX
We suggest to NOT use Homebrew, because we have experienced several issues handling the rest of the dependencies. Instead, we suggest using the installer provided in the Python webpage [https://www.python.org/downloads/release/python-368/](https://www.python.org/downloads/release/python-368/).

To verify python installed correctly just run `python3 --version` and you should get `Python 3.6.8`. 

## Install Pipenv

To install Pipenv just use the following Pip instruction `pip install pipenv`, though depending on your python installation you may need to call it with `sudo`. This may happen if you are using Ubuntu or the OSX Homebrew python installation. If the command `pip` is not found, use `pip3` instead. 

To verify if you have pipenv just run in a terminal `pipenv --version`, it should print something like `pipenv, version 2018.11.26`. We strongly suggest you to upgrade your pipenv version if it is older that 2018.11.26, because it has important bugfixes and performance improvements. To upgrade it just run `pip install pipenv --upgrade`.


## Download and Install PythonBridge

To install PythonBridge in a Pharo6.1 or Pharo7 image run the following script in a Playground:
```Smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
(Smalltalk at: #PBApplication) installPipenvEnvironment
``` 

The first part of the script is responsible of downloading the PythonBridge code and loading it in the image.
The second part of the script is responsible of creating a pipenv environment for isolating the python libraries used by the bridge.

If pipenv path is not found by Pharo you may need to provide the route manually. To know more about this go to the [Troubleshooting section](#troubleshooting).

Notice that each PythonBridge application has its own pipenv environment and must be created independently. Therefore, if we have 2 different applications, such as the base PythonBridge and KerasBridge we need to run the script for both:
```Smalltalk
PBApplication installPipenvEnvironment.
Keras installPipenvEnvironment.
``` 

## Manually creating Pipenv environment

If the second part of the script of the previous step `(Smalltalk at: #PBApplication) installPipenvEnvironment` was a success you may skip this step.

If Pharo was unable to create the Pipenv you may need to do it manually. For this you must run in a terminal the following script:
```bash
cd /PATH/TO/ICEBERG/PYTHON_BRIDGE/REPOSITORY
bash install_env.sh
```

To remove the pipenv environment run: 
```bash
cd /PATH/TO/ICEBERG/PYTHON_BRIDGE/REPOSITORY
pipenv --rm
```

## Test your installation

We have an extensive test suite and all the tests should be green.

Also we provide a Helloworld example:
```smalltalk
PBApplication do: [ 
	PBCF << (P3GBinaryOperator new
			left: 1;
			right: 2;
			operator: $+;
			yourself).
	PBCF send waitForValue
	 ]
```
<small>This examples should return 3.</small>

## Troubleshooting

### Pharo is unable to find Pipenv path
Some users have reported that Pharo was unable to find the path to Pipenv. To solve this you must find the path by yourself using the command which in a terminal:
```bash
which pipenv
```
Then you must set this path in PythonBridge by running the following script in a Playground:
```smalltalk
PBProcessHandler pipEnvPath: '/PATH/TO/PIPENV/BINARY'
```