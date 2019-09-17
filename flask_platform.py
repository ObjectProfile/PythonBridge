from flask import Flask, request
import http.client
import json
import threading

class FlaskMsgService:

    def __init__(self, port, pharo_port, feed_callback):
        self.port = port
        self.pharo_port = pharo_port
        self.feed_callback = feed_callback
        self.app = Flask('PythonBridge')
        self.app.use_reloader=False

        @self.app.route("/ENQUEUE", methods=["POST"])
        def eval_expression():
            data = request.get_json(force=True)
            feed_callback(data)
            return "OK"

        @self.app.route("/IS_ALIVE", methods=["POST"])
        def status_endpoint():
            return "PHARO_HOOKS RUNNING"
        
    def start(self):
        try:
            self.app.run(port=self.port)
        except OSError as err:
            print(str(err))
            exit(42)
    
    def start_on_thread(self):
        thread = threading.Thread(target=self.start, args=())
        thread.daemon = True
        thread.start()

    def send_async_message(self, msg):
        self.send_sync_message(msg)
    
    def send_sync_message(self, msg):
        conn = http.client.HTTPConnection("localhost", str(self.pharo_port))
        conn.request("POST", "/" + msg["type"], json.dumps(msg), {
            "Content-type": "application/json",
            "Accept": "text/plain"})
        response =  str(conn.getresponse().read().decode())
        return json.loads(response)

def build_service(port, pharo_port, feed_callback):
    return FlaskMsgService(port, pharo_port, feed_callback)