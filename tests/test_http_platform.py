import flask_platform
import unittest
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import requests
import json
import time

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
        print(text)
        return json.loads(text)


# def run(server_class=HTTPServer, handler_class=S, addr="localhost", port=8000):
#     server_address = (addr, port)
#     httpd = server_class(server_address, handler_class)

#     print(f"Starting httpd server on {addr}:{port}")
#     httpd.serve_forever()

class TestRegistry(unittest.TestCase):
    thread = None
    server_port = 9977
    server = HTTPServer(('localhost',server_port), TestHandler)

    @classmethod
    def post(cls,dictionary):
        response = requests.post('http://localhost:'+str(cls.server_port), data=dictionary)
        return response.json()

    @classmethod
    def setUpClass(cls):
        cls.start_server()

    @classmethod
    def start_server(cls):
        if cls.thread != None:
            return
        cls.thread = threading.Thread(target=cls._start_server, args=())
        cls.thread.daemon = True
        cls.thread.start()
        time.sleep(0.4)
    
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
        self.assertEqual(self.post({}), {'rr': 33})
        self.assertTrue(self.exec_flag)

    # def test_read_server(self):
    #     self.assertTrue(self.thread != None)
    #     def assert_handle(handler):
    #         self.assertEqual(handler.read_data(), {'ss': 44})
    #         self.write_answer({}, handler)
    #     TestHandler.callback = assert_handle
    #     self.assertEqual(self.post({'ss': 44}), {})
    #     self.assertTrue(self.exec_flag)