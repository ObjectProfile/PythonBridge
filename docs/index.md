---
# layout: home
layout: default
title: Home
nav_order: 1
description: "Pharo framework to create bridges between Pharo and Python. It is based on message sent from Pharo to Python that allow developers to execute arbitrary python expressions from Pharo preserving inspection and debugging."
permalink: /
---

# Talk to Python from Smalltalk, the smalltalk way
{: .fs-8 }

PythonBridge gives Smalltalk developers the capability of interacting and reusing any Python library directly from Smalltalk. The communication between both instances is transparent and most of the compelxity is handled directly by the framework. We want you to use Python, but develop Smalltalk. Currently, the bridge is open to the public in Pharo and we are conducting a closed beta for VisualWorks users.
{: .fs-5 .fw-300 }

[Get started now](#getting-started){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/ObjectProfile/PythonBridge){: .btn .btn-green .fs-5 .mb-4 .mb-md-0 }

<iframe width="560" height="315" src="https://www.youtube.com/embed/uKSHUVZs75k" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

---

## Getting started in Pharo

### Requirements

This project depends on Pharo6.1 (or newer), Python3.6 (or newer) and Pipenv.

To download Pharo 7 follow the instructions in the [Pharo website](https://pharo.org/download).

To install Python3.6 follow the instructions on the [Python download webpage](https://www.python.org/downloads/release/python-368/). To verify if you have Python3.6 just run in a terminal `python3.6 --version`, it should print something like `Python 3.6.4`.

To install Pipenv just use the following Pip instruction `pip3 install pipenv`. To verify if you have pipenv just run in a terminal `pipenv --version`, it should print something like `pipenv, version 2018.11.26`.

For troubleshooting on the dependencies installation go to our [Installation page](pages/pharo-installation#troubleshooting).

### Quick start: Download and install PythonBridge on a clean Pharo

1. To install PythonBridge on Pharo just run the following script in a Pharo Playground:
```smalltalk
Metacello new
    baseline: 'PythonBridge';
    repository: 'github://ObjectProfile/PythonBridge/src';
    load.
``` 
The first part of the script is responsible of downloading the PythonBridge code and loading it in the image.

1. Test the installation running the tests and inspecting the result of our HelloWorld example:
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
<small>This examples should return 3. The first time the bridge is started it may take a couple of minutes to install the pipenv environment required to run python.</small>


## Bridges based on PythonBridge

- [KerasBridge](https://objectprofile.github.io/KerasBridge)
