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

    def __init__(self, port):
        self.port = port
        self.client = None
        self.packer = msgpack.Packer()
        self.unpacker = msgpack.Unpacker()
        self.sync_table = {}
        self.async_handlers = {}

    def set_handler(self, msg_type, async_handler):
        self.async_handlers[msg_type] = async_handler

    def prim_handle(self):
        try:
            data = self.client.recv(2048)
            self.unpacker.feed(data)
            for msg in self.unpacker:
                self.prim_handle_msg(msg)
        except OSError:
            self.thread.stop()

    def setup_func(self):
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client.connect(('localhost', self.port))

    def stop(self):
        if self.thread is not None:
            self.thread.stop()
            self.thread = None
        if self.client is not None:
            self.client.close()
            self.client = None

    def send_answer(self, msg, answer):
        if answer['type'] != msg['type']:
            raise Exception('Type mismatch')
        answer['__sync'] = msg['__sync']
        self.send_async_message(answer)
    
    def is_running(self):
        return self.client != None
    
    def prim_handle_msg(self, raw_msg):
        msg = bin2text(raw_msg)
        msg_type = msg['type'] 
        if msg_type in self.async_handlers:
            self.async_handlers[msg['type']](msg)
        elif is_sync_msg(msg):
            sync_id = message_sync_id(msg)
            semaphore = self.sync_table[sync_id]
            self.sync_table[sync_id] = msg
            semaphore.release()
        else:
            raise Exception('Message couldn''t be handled')
        
    
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