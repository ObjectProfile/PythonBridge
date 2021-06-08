import msgpack
from PythonBridge.object_registry import registry

primitive_types = [
    type(None), 
    bool, 
    int,
    bytes,
    str,
    dict,
    list,
    memoryview,
    bytearray]

mapper = {}

def addMapping(key_type, mapping_function):
    mapper[key_type] = mapping_function

class MsgPackSerializer:
    def __init__(self):
        self.primitive_types = primitive_types

    def mapper(self):
        return mapper
    
    def default(self, obj):
        if type(obj) in self.primitive_types:
            return obj
        if type(obj) in self.mapper():
            return self.mapper()[type(obj)](obj)
        return {
            '__pyclass__': type(obj).__name__,
            '__pyid__': registry().register(obj)
            }

    def serialize(self, obj):
        return msgpack.packb(obj, default=self.default, use_bin_type=True)

    def deserialize(self, binary):
        return msgpack.unpackb(binary, raw=False)