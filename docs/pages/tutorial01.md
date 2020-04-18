# Tutorial: Using OpenCV from Smalltalk

This tutorial is a gentle introduction to PythonBridge. We use OpenCV as the running example. The tutorial assumes that you have PythonBridge correctly installed in your Smalltalk environment and have Python and Pipenv installed. If this is not the case, then you should follow the instruction given in https://objectprofile.github.io/PythonBridge/

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

Note that you should leave the packages `flask`, `requests`, `msgpack` as they are used by the PythonBridge itself to operate.
Now that we edited the `Pipenv` file, you should then update your pipenv environment. To do so, simply execute the `pipenv update` expression. You should see something like:

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

This tutorial will simply open an image using OpenCV. It is highly inspired from the [OpenCV online tutorial](https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_gui/py_image_display/py_image_display.html).

PythonBridge needs to launch a Python virtual machine and establish a communication channel to it. This is simply done using: 
```Smalltalk
PBApplication start.
```

Starting the Python Virtual Machine (VM) may take a few seconds in some cases. The python code we will execute is the following:

```Python
import cv2
img = cv2.imread('/Users/alexandrebergel/Desktop/iss.jpg',0)
cv2.imshow('image',img)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

I am here assuming spectacular picture from the [ISS](https://www.esa.int/Science_Exploration/Human_and_Robotic_Exploration/International_Space_Station/Where_is_the_International_Space_Station) is available on my desktop, under the name `iss.jpg`.

We first need to import OpenCV, using: 
```Smalltalk
PBCF sendAndWait: #cv2 asP3GI import.
```

We load the picture using OpenCV:

```Smalltalk
ref := '/Users/alexandrebergel/Desktop/iss.jpg'.
img := PBCF sendAndWait: (#cv2 asP3GI => #imread callWith: (Array with: filename)).
```

If you print (in Smalltalk), the variable `img` you should see `a ndarray (Proxy)`. OpenCV handles the picture as a numpy structure. Within Smalltalk, we only see a proxy since the image is living within the Python World. Note that we are using the `sendAndWait:` instruction as we wait for the completion of the Python import.

We can now open the image using:

```Smalltalk
PBCF send: (#cv2 asP3GI => #imshow callWith: (Array with: 'image' with: img)).
PBCF send: (#cv2 asP3GI => #waitKey callWith: (Array with: 0)).
PBCF send: (#cv2 asP3GI => #destroyAllWindows callWith: (Array new)).
```

Note that we simply use `send:` to send the Python commands, as there is no need to wait for their completion.

We can now close the Python connection:
```Smalltalk
PBApplication stop.
```

In theory, we should not need to shutdown the Python VM, however, due to a limitation of OpenCV in the way it handles the windows, it is simpler to do so.

## Applying transformation to an image

We can apply the OpenCV `cvtColor` [operation](https://docs.opencv.org/2.4/modules/imgproc/doc/miscellaneous_transformations.html#cvtcolor). We will turn a colored picture into gray using an adequate [transformation](https://docs.opencv.org/master/de/d25/imgproc_color_conversions.html#color_convert_rgb_gray).

The complete script is:

```Smalltalk
PBApplication start.
filename := '/Users/alexandrebergel/Desktop/iss.jpg'.
PBCF sendAndWait: #cv2 asP3GI import.
img := PBCF sendAndWait: (#cv2 asP3GI => #imread callWith: (Array with: filename)).
gray := PBCF sendAndWait: (#cv2 asP3GI => #cvtColor callWith: (Array with: img with: #cv2 asP3GI => #COLOR_BGR2GRAY)).

PBCF send: (#cv2 asP3GI => #imshow callWith: (Array with: 'image' with: gray)).
PBCF send: (#cv2 asP3GI => #waitKey callWith: (Array with: 0)).
PBCF send: (#cv2 asP3GI => #destroyAllWindows callWith: (Array new)).

PBApplication stop.
```

## Turning your script into an application

Obviously, you do not wish to directly face the Python scripting instruction. You can easily turn the script into a small class, titled `ImageViewer`, to completely hide the Python instructions:

```Smalltalk
Object subclass: #ImageViewer
	instanceVariableNames: 'filename'
	classVariableNames: ''
	package: 'OpenCVExample'
```

An accessor to set the image filename:
```Smalltalk
ImageViewer>>filename: aString
 filename := aString
```

The `show` methods to display the image:

```Smalltalk
ImageViewer>>show
	| img |
	PBApplication start.
	PBCF sendAndWait: #cv2 asP3GI import.
	img := PBCF sendAndWait: (#cv2 asP3GI => #imread callWith: (Array with: filename)).
	PBCF send: (#cv2 asP3GI => #imshow callWith: (Array with: 'image' with: img)).
	PBCF send: (#cv2 asP3GI => #waitKey callWith: (Array with: 0)).
	PBCF send: (#cv2 asP3GI => #destroyAllWindows callWith: (Array new)).
```
 
And to close the image:
```Smalltalk
ImageViewer>>delete
	PBApplication stop
```
 
You can now simply execute the following Smalltalk script, line by line:
```Smalltalk
v := ImageViewer new filename: '/Users/alexandrebergel/Desktop/iss.jpg'.
v show.
v delete
```

## What have we seen?

This short tutorial covers the basic functionalities of our bridge. We used an external Python modules within Smalltalk, and called a few Python functions within Pharo. We then wrapped our application into Smalltalk code to completely hide the Python code construction.

Have fun!
