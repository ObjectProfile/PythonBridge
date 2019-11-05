---
layout: default
permalink: /pages/vw-installation
title: Visual Works Installation
nav_order: 2
---

# VisualWorks Installation
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Dependencies

PythonBridge has two kind of dependencies, the ones that are required in the VisualWorks image to launch and communicate with Python and the dependencies related to the Python environment. Keep in mind that currently we only support PythonBridge running on VisualWorks on Windows.

### VisualWorks dependencies
{: #vwdep }
1. SUnitToo
1. HTTP
1. JSONReader (Public Store)
1. Sport (Public Store)
1. UUID
1. Swazoo (Public Store)

### Python dependencies
1. Python 3.6 or newer
1. Pip 3
1. Pipenv

### Python automatically installed dependencies
1. Flask
1. Msgpack
1. Requests

## Install Python 3.6
We suggest using the installer provided in the Python webpage [https://www.python.org/downloads/release/python-368/](https://www.python.org/downloads/release/python-368/). Follow the instructions in the installer and do not forget to put Python on the PATH (This step should be performed by the installer).

To verify python installed correctly just run `python --version` and you should get `Python 3.6.8`.
Also verify that pip has also been installed by running `pip -V` and you should get `pip 18.1 from ... (python 3.6)` 

## Install Pipenv

To install Pipenv just use the following Pip instruction `pip install pipenv`, though you may need to execute this line with admnistrator privileges.

To verify if you have pipenv just run in a terminal `pipenv --version`, it should print something like `pipenv, version 2018.11.26`. We strongly suggest you to upgrade your pipenv version if it is older than 2018.11.26, because it has important bugfixes and performance improvements. To upgrade it just run `pip install pipenv --upgrade`.


## Download and Install PythonBridge
Currently PythonBridge version for VisualWorks is on closed beta. Therefore, we required that all people or companies wishing to use PythonBridge directly request ObjectProfile a digital copy of the software. For this purpose send an email to `info@objectprofile.com`.

The next step is opening a VisualWorks 8.x image and install all the prerequisites detailed in [VisualWorks dependencies](#vwdep). They should be installed in that order, some of them are available directly from VW parcel manager and others need to be downloaded from Cincom Public Store.

After all prerequesites are installed we can install PythonBridge itself. You should have received a zip file from ObjectProfile which includes several parcels file. The first step is to extract them in a folder. Then, by executing the following script in a workspace, you need to select the folder with the parcels and let the tool automatically install PythonBridge.

```smalltalk
| dir |
dir := Dialog requestDirectoryName: 'Choose the PythonBridge parcels directory'.
dir isEmpty ifTrue: [^ self].
dir:= dir, (String with: Filename separator).
#('VwPharoPlatform' 'P3Generator' 'PythonBridgeBundle') do: [:fn | | file |
  file := dir, fn, '.pcl'.
  file asFilename exists ifFalse: [self error: 'Missing parcel!', file asString].
  Parcel loadParcelFrom: file asFilename
 ].
```

## Creating and referencing the Pipenv environment

In order to use PythonBridge we need a working pipenv environment capable of starting a PythonProcess with all the required dependencies. To generate this environment you need to clone or download [PythonBridge git repository](https://github.com/ObjectProfile/PythonBridge).

We then install the pipenv environment using our customized BAT script.
```
cd c:\PATH\TO\PYTHON\BRIDGE\REPOSITORY
windows_install_env.bat
```

In VisualWorks we need to add a reference to this environment so that PythonBridge is able to locate it and use it. To do it you need to execute the following script on a workspace replacing the example path to the PythonBridge repository folder path in your system:
```smalltalk
PBVwPlatform folderDict 
	at: PBApplication
	put: 'c:\PATH\TO\PYTHON\BRIDGE\REPOSITORY' asFilename
```

Then we need to create a symbolic link from the project repository folder to the base PythonBridge repository folder. In other words, this is a symbolic link to `.`, but this is important for extensions of PythonBridge that need a reference to the base code.

To create the link you need to execute the following in a shell with ADMINISTRATOR privileges:
```
mklink /D PythonBridge .
```

## Test your installation

<!-- We have an extensive test suite and all the tests should be green. -->
Currently, we are working on the test infrastructure of PythonBridge so they can be run on Pharo and VW. For this reason, VW tests are currently not passing. If you want to perform a basic test of the system we recommend you to run the following example:

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
This examples should return 3.

## Troubleshooting

### Python or Pip are installed but are not found
The most common reason for Windows to not be able to find Python is that Python folder are not appended to the PATH.

To ensure Python is in the PATH go to System Properties -> Advanced -> Environment Variables and check the 'PATH' environment varible. You should see two Python entries, one for the base directory and another one for the 'scripts' directory.

### Removing the pipenv environment
In case you wish to remove the pipenv environment run: 
```
cd c:\PATH\TO\PYTHON\BRIDGE\REPOSITORY
pipenv --rm
```