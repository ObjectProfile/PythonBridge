import msgpack
import socket
import _thread

class MsgPackSocket:

    def __init__(self, port, feed_callback):
        self.port = port
        self.feed_callback = feed_callback
        self.packer = msgpack.Packer()

    def start(self):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.bind(('localhost', self.port))
        server.listen(1)
        while True:
            self.client, address = server.accept()
            unpacker = msgpack.Unpacker()
            while True:
                unpacker.feed(client.recv(1))
                for value in unpacker:
                    self.feed_callback(value)
    
    def start_on_thread(self):
        _thread.start_new_thread(self.start, tuple())

    def send_message(self, msg):
        self.client.send(self.packer.pack(msg))