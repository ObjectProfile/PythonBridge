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
	bridge_globals.msg_service.send_async_message(data)

def notify_observer(obj, commandId, observerId):
	bridge_globals.logger.log("PYTHON: Notify observer " + str(commandId) + " " + str(observerId))
	data = {}
	data["type"] = "CALLBACK"
	data["commandId"] = commandId
	data["observerId"] = observerId
	data["value"] = convert_to_JSON(obj)
	rawValue = bridge_globals.msg_service.send_sync_message(data)['val']
	return convert_from_JSON(rawValue)

def notify_error(ex, command):
	bridge_globals.logger.log("Error on command: " + str(command.command_id()))
	bridge_globals.logger.log(str(ex))
	data = {}
	data["type"] = "ERR"
	data["errMsg"] = str(ex)
	data["trace"] = traceback.format_exc(100)
	data["id"] = command.command_id()
	return bridge_globals.msg_service.send_sync_message(data)

def bridge_inspect(obj):
	if hasattr(obj,'__dict__'):
		return obj.__dict__
	else:
		return {}