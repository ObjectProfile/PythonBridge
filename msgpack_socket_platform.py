import msgpack
import socket
import _thread
import threading
import time
from uuid import uuid1

# Messages supported by this sockets must be Dictionaries. This is because we use special key __sync to know if it is 
# a synchronized message or not. If it is we hook a semaphore to that id under the __sync key and after we receive the 
# value we store there the return message and signal the semaphore.
class MsgPackSocket:

    def __init__(self, port, async_handler):
        self.port = port
        self.client = None
        self.async_handler = async_handler
        self.packer = msgpack.Packer()
        self.sync_table = {}

    def async_handler(async_handler):
        self.async_handler = async_handler

    def start(self):
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client.connect(('localhost', self.port))
        unpacker = msgpack.Unpacker()
        while True:
            data = self.client.recv(2048)
            unpacker.feed(data)
            for msg in unpacker:
                self.async_handler(msg)

    def stop(self):
        if self.client is not None:
            self.client.close()
    
    # def is_running(self):
    #     try:
    #         self.client.send(bytearray(0))
    #         return True
    #     except socket.error:
    #         return False
    
    def handle_async_msg(self, msg):
        if is_sync_msg(msg):
            sync_id = message_sync_id(msg)
            semaphore = self.sync_table[sync_id]
            self.sync_table[sync_id] = msg
            semaphore.release()
        else:
            self.async_handler(msg)
    
    def start_on_thread(self):
        _thread.start_new_thread(self.start, tuple())
        time.sleep(.1)

    def send_async_message(self, msg):
        self.client.send(self.packer.pack(msg))
    
    def send_sync_message(self, msg):
        sync_id = mark_message_as_sync(msg)
        semaphore = threading.Semaphore(value=0)
        self.sync_table[sync_id] = semaphore
        self.send_async_message(msg)
        semaphore.acquire()
        ans = self.sync_table[sync_id]
        del self.sync_table[sync_id]
        return ans

    def is_sync_msg(msg):
        return '__sync' in msg
    
    def message_sync_id(msg):
        return msg['__sync']
    
    def mark_message_as_sync(msg):
        sync_id = uuid1().hex
        msg['__sync'] = sync_id
        return sync_id