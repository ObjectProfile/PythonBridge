import msgpack
import msgpack_serializer
from msgpack_serializer import *
import unittest
from object_registry import registry

class TestMsgpackSerializer(unittest.TestCase):

    def setUp(self):
        self.serializer = MsgPackSerializer()
    
    def assert_encode_raw(self, obj, expected):
        self.assertEqual(self.serializer.serialize(obj),expected)

    def assert_encode(self, obj, expected):
        self.assertEqual(self.serializer.deserialize(self.serializer.serialize(obj)),expected)

    def test_encode_int(self):
        self.assert_encode_raw(3, b'\x03')

    def test_encode_float(self):
        self.assert_encode_raw(5.5, b'\xcb\x40\x16\x00\x00\x00\x00\x00\x00')
    
    def test_add_mapping(self):
        msgpack_serializer.addMapping(type(self), lambda obj: 'Foooo!')
        self.assert_encode(self,'Foooo!')

    def test_encode_obj(self):
        registry().register_with_id(self.serializer,'337')
        self.assert_encode(self.serializer,{'__pyclass__': "MsgPackSerializer", "__pyid__": '337'})