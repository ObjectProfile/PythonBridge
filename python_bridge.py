import argparse
import threading
import sys
from PythonBridge import bridge_globals, bridge_hooks, flask_platform, msgpack_socket_platform
from PythonBridge.bridge_hooks import *
from PythonBridge.object_registry import registry

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
			bridge_globals.globalCommandList.drop_queue()
		if actionSymbol == "REPLACE_COMMAND":
			commandDict = actionDict["command"]
			bridge_globals.globalCommandList.push_command_at_first(EvalCommand(commandDict["commandId"], commandDict["statements"], commandDict["bindings"]))
		 
	def command_id(self):
		return self.commandId

class Logger():
	def log(self, msg):
		print(str(msg), file=sys.stderr, flush=True)

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

def deserialize(text):
	return bridge_globals.msg_service.serializer.deserialize(text)

def enqueue_command(data):
	bridge_globals.globalCommandList.push_command(EvalCommand(
										data["commandId"], 
										data["statements"],
										{k: deserialize(v) for k, v in data["bindings"].items()}))

def run_bridge():
	ap = argparse.ArgumentParser()
	ap.add_argument("-p", "--port", required=False,
		help="port to be used for receiving instructions")
	ap.add_argument("-o", "--pharo", required=True,
		help="port to be used for sending notifications back to pharo")
	ap.add_argument("-m", "--method", required=False,
		help="identifier for communication protocol strategy http or msgpack")
	ap.add_argument("--log", required=False, const=True, nargs="?",
    	help="enable logging")
	args = vars(ap.parse_args())

	bridge_globals.pharoPort = args["pharo"]
	if args["log"]:
		bridge_globals.logger = Logger()
	else:
		bridge_globals.logger = NoLogger()
	bridge_globals.pyPort = args["port"]
	bridge_globals.globalCommandList = PythonCommandList()
	globalCommandList = bridge_globals.globalCommandList
	env = clean_locals_env()
	msg_service = None 
	if args["port"] == None:
		args["port"] = '0'
	if args["method"] == None:
		args["method"] = 'http'
	if args["method"] == 'http':
		from PythonBridge import flask_platform
		msg_service = flask_platform.build_service(int(args["port"]), int(args["pharo"]), enqueue_command)
	elif args["method"] == 'msgpack':
		from PythonBridge import msgpack_socket_platform
		msg_service = msgpack_socket_platform.build_service(int(args["port"]), int(args["pharo"]), enqueue_command)
	else:
		raise Exception("Invalid communication strategy.")
	bridge_globals.msg_service = msg_service
	msg_service.start()
	bridge_globals.logger.log("PYTHON: Start consuming commands")
	while True:
		command = globalCommandList.consume_command()
		bridge_globals.logger.log("PYTHON: Executing command " + command.command_id())
		bridge_globals.logger.log("PYTHON: " + command.statements)
		command.execute_using_env(env)
		bridge_globals.logger.log("PYTHON: Finished command execution")

if __name__ == "__main__":
	run_bridge()