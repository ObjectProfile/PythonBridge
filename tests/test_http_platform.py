import unittest
from PythonBridge import bridge_globals, flask_platform
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import requests
import json
import time

class NoLogger():
	def log(self, msg):
		pass

def signal_error(handler):
    raise Exception("ERROR!!!!")

class TestHandler(BaseHTTPRequestHandler):
    callback = signal_error

    def _set_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    # def _html(self, message):
    #     """This just generates an HTML document that includes `message`
    #     in the body. Override, or re-write this do do more interesting stuff.
    #     """
    #     content = f"<html><body><h1>{message}</h1></body></html>"
    #     return content.encode("utf8")  # NOTE: must return a bytes object!

    def do_GET(self):
        self._set_headers()
        self.wfile.write('<html><body><h1>LALALA</h1></body></html>'.encode("utf8"))

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        # Doesn't do anything with posted data
        self._set_headers()
        self.callback() # Very ugly, callback is not a method, but an external lambda that receives self.
                        # Though Python treats it like a method.

    def read_data(self):
        text = self.rfile.read(int(self.headers.get('Content-Length'))).decode("utf-8")
        return json.loads(text)


# def run(server_class=HTTPServer, handler_class=S, addr="localhost", port=8000):
#     server_address = (addr, port)
#     httpd = server_class(server_address, handler_class)

#     print(f"Starting httpd server on {addr}:{port}")
#     httpd.serve_forever()

class TestHTTPPlatform(unittest.TestCase):
    thread = None
    msg_service = None
    server_port = 9977
    python_port = 9978
    server = HTTPServer(('localhost',server_port), TestHandler)

    @classmethod
    def post(cls,dictionary, port=python_port,route=''):
        response = requests.post('http://localhost:'+str(port)+'/'+route, data=json.dumps(dictionary))
        return response.json()

    @classmethod
    def setUpClass(cls):
        bridge_globals.logger = NoLogger()
        cls.start_server()
        cls.start_msg_service()
        time.sleep(0.5)

    @classmethod
    def start_server(cls):
        if cls.thread != None:
            return
        cls.thread = threading.Thread(target=cls._start_server, args=())
        cls.thread.daemon = True
        cls.thread.start()

    @classmethod
    def start_msg_service(cls):
        if cls.msg_service != None:
            return
        cls.msg_service = flask_platform.build_service(cls.python_port,cls.server_port,signal_error)
        cls.msg_service.start()
    
    @classmethod
    def _start_server(cls):
        cls.continue_running = True
        while cls.continue_running:
            cls.server.handle_request()

    def write_answer(self, answer, handler):
        self.exec_flag = True
        return handler.wfile.write(json.dumps(answer).encode("utf8"))

    def setUp(self):
        TestHandler.callback = signal_error
        self.exec_flag = False
    
    def test_write_server(self):
        self.assertTrue(self.thread != None)
        TestHandler.callback = lambda handler: self.write_answer({'rr': 33}, handler)
        self.assertEqual(self.post({}, port=self.server_port), {'rr': 33})
        self.assertTrue(self.exec_flag)

    def test_read_server(self):
        self.assertTrue(self.thread != None)
        def assert_handle(handler):
            self.assertEqual(handler.read_data(), {'ss': 44})
            self.write_answer({}, handler)
        TestHandler.callback = assert_handle
        self.assertEqual(self.post({'ss': 44}, port=self.server_port), {})
        self.assertTrue(self.exec_flag)

    def test_send_sync_msg(self):
        self.sync_id = None
        def assert_handle(handler):
            data = handler.read_data()
            self.assertEqual(data['val'], 3)
            self.assertEqual(data['type'], 'MSG')
            self.sync_id = data['__sync']
            self.write_answer({'type': 'MSG', 'foo':7, '__sync': self.sync_id}, handler)
        TestHandler.callback = assert_handle
        ans = self.msg_service.send_sync_message({'type': 'MSG', 'val': 3})
        self.assertEqual({'type': 'MSG', 'foo':7, '__sync': self.sync_id}, ans)
        self.assertTrue(self.exec_flag)

    def test_send_async_msg(self):
        def assert_handle(handler):
            data = handler.read_data()
            self.assertEqual(data['val'], 3)
            self.assertEqual(data['type'], 'MSG')
            self.write_answer({}, handler)
        TestHandler.callback = assert_handle
        self.msg_service.send_async_message({'type': 'MSG', 'val': 3})
        self.assertTrue(self.exec_flag)

    def test_is_alive(self):
        self.assertEqual(self.post({'type':'IS_ALIVE'}, route='IS_ALIVE'), {})

    def test_enqueue_callback(self):
        def assert_enqueue_handle(msg):
            self.exec_flag = True
            self.assertEqual(msg, {'type':'ENQUEUE', 'data':'FFFFFFF'})
        self.msg_service.feed_callback = assert_enqueue_handle
        self.post({'type':'ENQUEUE', 'data':'FFFFFFF'}, route='ENQUEUE')
        self.exec_flag = True