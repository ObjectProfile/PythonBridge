# Tutorial

This tutorial is a gentle introduction to using PythonBridge. It is written for Pharo, however, it works equally well for VisualWorks.

The tutorial assumes that you have PythonBridge correctly installed in your Smalltalk environment and have Python and Pipenv installed. If this is not the case, then you should follow the instruction given in https://objectprofile.github.io/PythonBridge/

## How do I know if Python and Pipenv are correctly installed?
If you have PythonBridge installed, and you do not know if you Python environment is correctly setup, the easy way to check this is evaluate the following expression:

```Smalltalk
PBApplication do: [ 
 PBCF << (P3GBinaryOperator new left: 1; right: 2; operator: $+; yourself).
 PBCF send waitForValue ]
```

If it returns `3`, then your Python setting is properly installed and you can continue the tutorial. If it does not return 3, but raises en error, then you should revise your Python installation. In case you a VisualWorks user, do not forget to manually set the path to `Pipenv.exe` as specified [here](https://objectprofile.github.io/PythonBridge/pages/vw-installation). 

## Installing the OpenCV Python module

Before jumping into Smalltalk, we need to make sure that the OpenCV Python library is installed in your Pipenv environment before continuing. You need to open a terminal that points to the `PythonBridge` folder, next to your image. Edit the file called `Pipenv` and add the line `opencv-python = "*"` in the `[packages]` section. You `Pipfile` should be very similar to:

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
opencv-python = "*"

[requires]
python_version = "3"
```

