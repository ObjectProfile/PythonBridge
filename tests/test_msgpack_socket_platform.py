import unittest
import socket
import threading
import time
import msgpack
import msgpack_socket_platform
from msgpack_socket_platform import bin2text
import stoppable_thread

TEST_PORT = 7777

def wait_a_little():
    time.sleep(.05)

def do_nothing(msg):
    pass

class TestMsgPackBin2Text(unittest.TestCase):
    def test_simple_dict(self):
        msg = {b'type': b'FOO', b'val': 33}
        self.assertEqual(
            bin2text(msg),
            {'type': 'FOO', 'val': 33})
    
    def test_arr(self):
        arr = [33, b'foo', b'bar', []]
        self.assertEqual(
            bin2text(arr),
            [33, 'foo', 'bar', []])

    def test_bin(self):
        self.assertEqual(bin2text(b'foo'),'foo')

    def test_composed_dict(self):
        msg = {b'type': b'FOO', b'val': [b'33']}
        self.assertEqual(
            bin2text(msg),
            {'type': 'FOO', 'val': ['33']})

class TestMsgPackSocket(unittest.TestCase):

    def setUp(self):
        self.start_stub_server()
        self.msg_service = msgpack_socket_platform.MsgPackSocketPlatform(TEST_PORT)
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
                self.server_handler(bin2text(msg))
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
            self.assertEqual(msg,{'type': 'FOO', 'val': 33})
            flag = True
        self.server_handler = handler
        self.msg_service.send_async_message({'type': 'FOO', 'val': 33})
        wait_a_little()
        self.assertTrue(flag)

    def test_send_sync_msg(self):
        flag = False
        sync_id = None
        def handler(msg):
            nonlocal flag
            nonlocal sync_id
            sync_id = msg['__sync']
            self.assertEqual(msg,{'type': 'FOO', 'val': 33, '__sync': sync_id})
            self.prim_send_msg({'type': 'FOO', 'val': 42, '__sync': sync_id})
            flag = True
        self.server_handler = handler
        ans = self.msg_service.send_sync_message({'type': 'FOO', 'val': 33})
        self.assertEqual(ans, {'type': 'FOO', 'val': 42, '__sync': sync_id})
        self.assertTrue(flag)

    def test_handle_async(self):
        flag = False
        def handler(msg):
            nonlocal flag
            self.assertEqual(msg,{'type': 'FOO', 'val': 33})
            flag = True
        self.msg_service.set_handler('FOO',handler)
        self.prim_send_msg({'type': 'FOO', 'val': 33})
        wait_a_little()
        self.assertTrue(flag)

    def test_handle_sync(self):
        flag1 = False
        flag2 = False
        def service_handler(msg):
            nonlocal flag1
            self.assertEqual(msg,{'type': 'FOO', '__sync': 'abcde12345', 'val': 33})
            flag1 = True
            self.msg_service.send_answer(msg, {'type': 'FOO', 'val': 42})
        self.msg_service.set_handler('FOO',service_handler)
        def test_handler(msg):
            nonlocal flag2
            self.assertEqual(msg,{'type': 'FOO', '__sync': 'abcde12345', 'val': 42})
            flag2 = True
        self.server_handler = test_handler
        self.prim_send_msg({'type': 'FOO', '__sync': 'abcde12345', 'val': 33})
        wait_a_little()
        self.assertTrue(flag1)
        self.assertTrue(flag2)