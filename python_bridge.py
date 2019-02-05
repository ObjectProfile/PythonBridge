from flask import Flask, request
import http.client
import argparse
import threading
import json
import sys
from PythonBridge import bridge_globals, bridge_hooks
from PythonBridge.bridge_hooks import *

class ThreadedFlask():
	def __init__(self, flaskApp, port):
		self.flaskApp = flaskApp
		self.port = port
		thread = threading.Thread(target=self.run, args=())
		thread.daemon = True
		thread.start()

	def run(self):
		try:
			self.flaskApp.run(port=self.port)
		except OSError as err:
			print(str(err))
			exit(48)

class EvalCommand:
	statements = ""
	binding = {}
	commandId = 0

	def __init__(self, commandId, statements, bindings):
		self.statements = statements
		self.commandId = commandId
		self.bindings = bindings

	def execute_using_env(self, env):
		try:
			env.update(self.bindings)
			exec(self.statements, globals(), env)
		except Exception as err:
			self.perform_proceed_action(notify_error(err,self))

	def perform_proceed_action(self, actionDict):
		actionSymbol = actionDict['action']
		if actionSymbol == "IGNORE":
			pass
		if actionSymbol == "DROP_QUEUE":
			globalCommandList.drop_queue()
		if actionSymbol == "REPLACE_COMMAND":
			commandDict = actionDict["command"]
			globalCommandList.push_command_at_first(EvalCommand(commandDict["commandId"], commandDict["statements"], commandDict["bindings"]))
		 
	def command_id(self):
		return self.commandId

class Logger():
	def log(self, msg):
		print(str(msg), file=sys.stderr)

class NoLogger():
	def log(self, msg):
		pass

# This List is thought to be multi-producer and single-consumer. For optimal results wait for push_command return value to push another command that depends on the previous one.
class PythonCommandList:
	currentCommandIndex = 0
	commandList = []
	listLock = threading.Lock()
	consumeSemaphore = threading.Semaphore(value=0)

	# This method locks the thread until the command has been succesfully appended to the list. Even though that it has a lock inside, we do not expect long waiting time.
	def push_command(self, aCommand):
		self.listLock.acquire()
		self.commandList.append(aCommand)
		commandIndex = len(self.commandList) - 1
		self.listLock.release()
		self.consumeSemaphore.release()
		return commandIndex

	def push_command_at_first(self, aCommand):
		self.listLock.acquire()
		self.commandList.insert(self.currentCommandIndex, aCommand)
		self.listLock.release()
		self.consumeSemaphore.release()
		return self.currentCommandIndex

	def drop_queue(self):
		self.listLock.acquire()
		self.consumeSemaphore = threading.Semaphore(value=0)
		self.currentCommandIndex = len(self.commandList)
		self.listLock.release()

	def consume_command(self):
		repeatMonitorFlag = True
		while repeatMonitorFlag:
			self.consumeSemaphore.acquire()
			self.listLock.acquire()
			repeatMonitorFlag = False
			if(self.currentCommandIndex >= len(self.commandList)):
				repeatMonitorFlag = True
				self.listLock.release()
		command = self.commandList[self.currentCommandIndex]
		self.currentCommandIndex += 1
		self.listLock.release()
		return command

	def get_current_command(self):
		if self.currentCommandIndex == 0:
			return None
		self.listLock.acquire()
		command = self.commandList[self.currentCommandIndex-1]
		self.listLock.release()
		return command

	def get_command_list(self):
		self.listLock.acquire()
		listCopy = self.commandList.copy()
		self.listLock.release()
		return listCopy

#### UTILS FUNCTIONS
def clean_locals_env():
	return locals()

def run_bridge():
	##### FLASK API
	app = Flask(__name__)
	app.use_reloader=False

	@app.route("/eval", methods=["POST"])
	def eval_expression():
		data = request.get_json(force=True)
		globalCommandList.push_command(EvalCommand(
										data["commandId"], 
										data["statements"],
										{k: convert_from_JSON(v) for k, v in data["bindings"].items()}))
		return "OK"

	@app.route("/status", methods=["GET"])
	def status_endpoint():
		return "PHARO_HOOKS RUNNING"

	##### MAIN PROGRAM
	ap = argparse.ArgumentParser()
	ap.add_argument("-p", "--port", required=True,
		help="port to be used for receiving instructions")
	ap.add_argument("-o", "--pharo", required=True,
		help="port to be used for sending notifications back to pharo")
	ap.add_argument("--log", required=False, const=True, nargs="?",
    	help="enable logging")
	args = vars(ap.parse_args())

	bridge_globals.pharoPort = args["pharo"]
	if args["log"]:
		print("YES LOG")
		bridge_globals.logger = Logger()
	else:
		print("NO LOG")
		bridge_globals.logger = NoLogger()
	bridge_globals.pyPort = args["port"]
	globalCommandList = PythonCommandList()
	env = clean_locals_env()

	ThreadedFlask(app,int(bridge_globals.pyPort))

	while True:
		command = globalCommandList.consume_command()
		bridge_globals.logger.log("PYTHON: Executing command " + command.command_id())
		bridge_globals.logger.log("PYTHON: " + command.statements)
		command.execute_using_env(env)
		bridge_globals.logger.log("PYTHON: Finished command execution")

if __name__ == "__main__":
	run_bridge()