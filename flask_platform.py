from flask import Flask, request
import http.client
import json
import threading
from PythonBridge import bridge_globals, json_encoder, bridge_utils
import sys
import logging
import requests

class FlaskMsgService:

    def __init__(self, port, pharo_port, feed_callback):
        self.serializer = json_encoder.JsonSerializer()
        log = logging.getLogger('werkzeug')
        log.setLevel(logging.ERROR)
        self.thread = None
        self.port = port
        self.pharo_port = pharo_port
        self.feed_callback = feed_callback
        self.app = Flask('PythonBridge')
        self.app.use_reloader=False
        self.session = requests.Session()
        self.session.trust_env = True

        @self.app.route("/ENQUEUE", methods=["POST"])
        def eval_expression():
            data = request.get_json(force=True)
            self.feed_callback(data)
            return "{}"

        @self.app.route("/IS_ALIVE", methods=["POST"])
        def status_endpoint():
            return "{}"
        
    def addMapping(self, key_type, mapping_function):
        json_encoder.addMapping(key_type, mapping_function)

    def _start(self):
        try:
            self.app.run(port=self.port)
        except OSError as err:
            bridge_globals.logger.log('Critical Error:' + str(err))
            exit(42)
    
    def start(self):
        self.thread = threading.Thread(target=self._start, args=())
        self.thread.daemon = True
        self.thread.start()

    def is_running(self):
        return self.thread != None

    def stop(self):
        pass

    def send_async_message(self, msg):
        self.send_sync_message(msg)
    
    def send_sync_message(self, msg):
        msg['__sync'] = bridge_utils.random_str()
        bridge_globals.logger.log("SYNC_MSG: " + json.dumps(msg))
        response = self.session.post(
            'http://localhost:' + str(self.pharo_port) + '/' + msg['type'], 
            data=json.dumps(msg),
            headers={'content-type': 'application/json'}, 
            allow_redirects=True).content.decode('utf-8')
        bridge_globals.logger.log("SYNC_ANS: " + response)
        return json.loads(response)

def build_service(port, pharo_port, feed_callback):
    return FlaskMsgService(port, pharo_port, feed_callback)