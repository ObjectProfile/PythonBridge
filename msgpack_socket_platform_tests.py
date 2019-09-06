import unittest
import socket
import threading
import time
from msgpack_socket_platform import *

TEST_PORT = 7777

def do_nothing(msg):
    pass

class TestMsgPackSocket(unittest.TestCase):

    def setUp(self):
        # Run a server to listen for a connection and then close it
        self.continue_flag = True
        self.server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # SOL_SOCKET and SOREUSEADDR allow kernel to reuse socket and allow us to rapidly create and destroy sockets
        self.server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server_sock.bind(('127.0.0.1', TEST_PORT))
        self.server_sock.listen(1)
        thread = threading.Thread(target=self.echo_server, args=())
        thread.daemon = True
        thread.start()
        self.msg_service = MsgPackSocket(TEST_PORT, do_nothing)

    def tearDown(self):
        self.continue_flag = False
        self.server_sock.close()
        self.msg_service.stop()
    
    def echo_server(self):
        self.server_client, _ = self.server_sock.accept()
        while self.continue_flag:
            data = self.server_client.recv(2048)
            self.server_client.send(data)

    def test_connect(self):
        self.msg_service.start_on_thread()
        self.assertIsNotNone(self.server_client)
        self.assertIsNotNone(self.msg_service.client)
    
    def test_close(self):
        self.msg_service.start_on_thread()
        self.assertIsNotNone(self.server_client)
        self.assertIsNotNone(self.msg_service.client)