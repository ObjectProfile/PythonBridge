# Tutorial: Using OpenCV from Smalltalk

This tutorial is a gentle introduction to using PythonBridge using OpenCV. It is written for Pharo, however, it works equally well for VisualWorks.

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

You should then update your pipenv environment. To do so, you should simply execute the `pipenv update` expression. You should see something like:

```
➜  PythonBridge git:(master) ✗ pipenv update
Running $ pipenv lock then $ pipenv sync.
Locking [dev-packages] dependencies…
Locking [packages] dependencies…
✔ Success! 
Updated Pipfile.lock (bc0ce1)!
Installing dependencies from Pipfile.lock (bc0ce1)…
  🐍   ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉ 14/14 — 00:00:10
To activate this project's virtualenv, run pipenv shell.
Alternatively, run a command inside the virtualenv with pipenv run.
All dependencies are now up-to-date!
```

You can now close your terminal and stay within the confortable world of Smalltalk. We will not have to use the terminal anymore.

## Your first OpenCV script

We will first do some scripting to illustrate the essence of PythonBridge. We will then move into defining a proper application, without having the exposition to Python.

This tutorial is highly inspired from the [OpenCV online tutorial](https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_gui/py_image_display/py_image_display.html).

```Smalltalk
PBApplication start.
ref := 'c:\Users\infan\Pictures\pic.png' asFilename.
PBCF sendAndWait: #cv2 asP3GI import.
```
