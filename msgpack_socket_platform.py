import msgpack
import socket
import _thread
import threading
import time
import stoppable_thread
from uuid import uuid1

# Messages supported by this sockets must be Dictionaries. This is because we use special key __sync to know if it is 
# a synchronized message or not. If it is we hook a semaphore to that id under the __sync key and after we receive the 
# value we store there the return message and signal the semaphore.
class MsgPackSocketPlatform:

    def __init__(self, port, async_handler):
        self.port = port
        self.client = None
        self.packer = msgpack.Packer()
        self.unpacker = msgpack.Unpacker()
        self.sync_table = {}
        self.async_handler = self.set_handler(async_handler)

    def set_handler(self, async_handler):
        self.async_handler = lambda this, msg: async_handler(msg)

    def prim_handle(self):
        try:
            data = self.client.recv(2048)
            print('FOOOO')
            self.unpacker.feed(data)
            for msg in self.unpacker:
                print(msg)
                self.handle_async_msg(msg)
        except OSError:
            self.thread.stop()

    def setup_func(self):
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client.connect(('localhost', self.port))

    def stop(self):
        if self.thread is not None:
            self.thread.stop()
        if self.client is not None:
            self.client.close()
    
    # def is_running(self):
    #     try:
    #         self.client.send(bytearray(0))
    #         return True
    #     except socket.error:
    #         return False
    
    def handle_async_msg(self, raw_msg):
        msg = bin2text(raw_msg)
        if is_sync_msg(msg):
            sync_id = message_sync_id(msg)
            semaphore = self.sync_table[sync_id]
            self.sync_table[sync_id] = msg
            semaphore.release()
        else:
            self.async_handler(self,msg)
    
    def start(self):
        self.thread = stoppable_thread.StoppableThread(
            loop_func= self.prim_handle,
            setup_func= self.setup_func)
        self.thread.start()
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

def bin2text(msg):
    if type(msg) == list:
        return [bin2text(k) for k in msg]
    if type(msg) == dict:
        return {bin2text(k): bin2text(v) for k, v in msg.items()}
    if type(msg) == bytes:
        return msg.decode("utf-8")
    return msg