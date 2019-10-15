import unittest
import socket
import threading
import time
import msgpack
import msgpack_socket_platform
import stoppable_thread

TEST_PORT = 7777

def wait_a_little():
    time.sleep(.05)

def do_nothing(msg):
    pass

class TestMsgPackSocket(unittest.TestCase):

    def setUp(self):
        self.start_stub_server()
        self.msg_service = msgpack_socket_platform.MsgPackSocketPlatform(TEST_PORT, do_nothing)
        self.msg_service.start()

    def tearDown(self):
        self.thread.stop()
        self.msg_service.stop()
        self.server_client.close()
        self.server_sock.close()
        self.thread.join()

    def start_stub_server(self):
         # Run a server to listen for a connection and then close it
        self.server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # SOL_SOCKET and SOREUSEADDR allow kernel to reuse socket and allow us to rapidly create and destroy sockets
        self.server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server_sock.bind(('127.0.0.1', TEST_PORT))
        self.server_sock.listen(1)
        self.server_handler = do_nothing
        self.unpacker = msgpack.Unpacker()
        self.packer = msgpack.Packer()
        self.thread = stoppable_thread.StoppableThread(
            loop_func= self.prim_handle,
            setup_func= self.setup_func)
        self.thread.start()

    def setup_func(self):
        self.server_client, _ = self.server_sock.accept()
    
    def prim_handle(self):
        try:
            data = self.server_client.recv(2048)
            self.unpacker.feed(data)
            for msg in self.unpacker:
                self.server_handler(msg)
        except OSError:
            self.thread.stop()
    
    def prim_send_msg(self, msg):
        self.server_client.send(self.packer.pack(msg))

    def test_connect(self):
        self.assertIsNotNone(self.server_client)
        self.assertIsNotNone(self.msg_service.client)

    def test_send_async_msg(self):
        flag = False
        def handler(msg):
            nonlocal flag
            self.assertEqual(msg,{b'type': b'FOO', b'val': 33})
            flag = True
        self.server_handler = handler
        self.msg_service.send_async_message({'type': 'FOO', 'val': 33})
        wait_a_little()
        self.assertTrue(flag)