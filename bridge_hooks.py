from flask import Flask, request
import http.client
import argparse
import threading
import json
import sys
import traceback
from PythonBridge import bridge_globals
from PythonBridge import bridge_encoder

def convert_to_JSON(obj):
	return json.dumps(obj, cls=bridge_encoder.BridgeEncoder)

def convert_from_JSON(text):
	return json.loads(text)

def observer(commandId, observerId):
	return lambda obj: notify_observer(obj, commandId, observerId)

#### NOTIFICATION FUNCTIONS
def notify(obj, notificationId):
	bridge_globals.logger.log("PYTHON: Notify " + str(notificationId))
	data = {}
	data["type"] = "EVAL"
	data["id"] = notificationId
	data["value"] = convert_to_JSON(obj)
	conn = http.client.HTTPConnection("localhost", str(bridge_globals.pharoPort))
	conn.request("POST", "/EVAL", json.dumps(data), {
		"Content-type": "application/json",
		"Accept": "text/plain"})
	conn.getresponse()
	bridge_globals.logger.log("PYTHON: Finish notify")

def notify_observer(obj, commandId, observerId):
	bridge_globals.logger.log("PYTHON: Notify observer " + str(commandId) + " " + str(observerId))
	data = {}
	data["type"] = "CALLBACK"
	data["commandId"] = commandId
	data["observerId"] = observerId
	data["value"] = convert_to_JSON(obj)
	conn = http.client.HTTPConnection("localhost", str(bridge_globals.pharoPort))
	conn.request("POST", "/CALLBACK", json.dumps(data), {
		"Content-type": "application/json",
		"Accept": "text/plain"})
	conn.getresponse()
	bridge_globals.logger.log("PYTHON: Finish notify observer")

def notify_error(ex, command):
	bridge_globals.logger.log("Error on command: " + str(command.command_id()))
	bridge_globals.logger.log(str(ex))
	data = {}
	data["type"] = "ERR"
	data["errMsg"] = str(ex)
	data["trace"] = traceback.format_exc(100)
	data["id"] = command.command_id()
	conn = http.client.HTTPConnection("localhost", str(bridge_globals.pharoPort))
	conn.request("POST", "/ERR", json.dumps(data), {
		"Content-type": "application/json",
		"Accept": "text/plain"})
	response = str(conn.getresponse().read().decode())
	bridge_globals.logger.log(response)
	return json.loads(response)