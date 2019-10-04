---
layout: default
permalink: /pages/pharo-installation
title: Pharo Installation
nav_order: 2
---

# Pharo Installation
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
1. Msgpack

### Pharo Automatically installed dependencies
1. Python3Generatoy
1. Zinc
1. NeoJSON
1. OSSubprocess
1. Msgpack

## Install Python 3.6

### Ubuntu
We suggest using `sudo apt-get install python3.6`, this should avoid most of the problems.

### OSX
We suggest to NOT use Homebrew, because we have experienced several issues handling the rest of the dependencies. Instead, we suggest using the installer provided in the Python webpage [https://www.python.org/downloads/release/python-368/](https://www.python.org/downloads/release/python-368/).

To verify python installed correctly just run `python3 --version` and you should get `Python 3.6.8`. 

## Install Pipenv

To install Pipenv just use the following Pip instruction `pip install pipenv`, though depending on your python installation you may need to call it with `sudo`. This may happen if you are using Ubuntu or the OSX Homebrew python installation. If the command `pip` is not found, use `pip3` instead. 

To verify if you have pipenv just run in a terminal `pipenv --version`, it should print something like `pipenv, version 2018.11.26`. We strongly suggest you to upgrade your pipenv version if it is older than 2018.11.26, because it has important bugfixes and performance improvements. To upgrade it just run `pip install pipenv --upgrade`.


## Download and Install PythonBridge

To install PythonBridge in a Pharo6.1 or Pharo7 image run the following script in a Playground:
```Smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
``` 

The first part of the script is responsible of downloading the PythonBridge code and loading it in the image.

If pipenv path is not found by Pharo you may need to provide the route manually. To know more about this go to the [Troubleshooting section](#troubleshooting).

## Manually creating Pipenv environment

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
PBPipenvPyStrategy pipEnvPath: '/PATH/TO/PIPENV/BINARY'
```

### Executing PythonBridge in Windows
PythonBridge uses OSSubprocess to start the python process from Pharo. OSSubprocess does not work on Windows, therefore, we can not start python from Pharo in Windows.

Nevertheless, PythonBridge should work on Windows systems if the user start python manually. To do this follow these instructions:
1. Install [Python](https://www.python.org/downloads/release/python-368/) and [Pipenv](https://pipenv.readthedocs.io/en/latest/install/#installing-pipenv).
1. Download PythonBridge by executing the following script on a playground: 
```
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
```
1. Set the python handler strategy to manual by executing the following in a playground:
```
PBManualPyStrategy setAsDefault
```
1. In a terminal go to the folder of the repository of the project you want to run (PythonBridge, KerasBridge, ...). To know the exact location of the iceberg repository folder print the result of the following script in a playground:
```
PBApplication repositoryFileReference. "For the repository of PythonBridge"
Keras repositoryFileReference. "For the repository of KerasBridge"
```
1. Once in the folder of the repository, create the Pipenv environment:
```bash
pipenv install
```
1. Create symbolic link to PythonBridge repository:
```
mklink /D PythonBridge \Path\To\PythonBridge\Repository
```
This should be done on all projects to reference the original PythonBridge repository folder.
1. Start the python process by executing `pipenv run python start_bridge.py --port 7100 --pharo 7200` in a terminal.
1. Test that the application is running normally by executing this example:
```
PBApplication do: [ 
 PBCF << (P3GBinaryOperator new
                     left: 1;
                     right: 2;
                     operator: $+;
                     yourself).
 PBCF send waitForValue
  ]
```
To try this code snippet using KerasBridge replace `PBApplication` -> `Keras` and `PBCF` -> `KCF`.
