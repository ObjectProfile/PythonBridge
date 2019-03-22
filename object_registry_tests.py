import object_registry
import unittest

class Foo:
    pass

class TestRegistry(unittest.TestCase):

    def setUp(self):
        self.registry = object_registry.Registry()
    
    def test_register(self):
        obj = Foo()
        newId = self.registry.register(obj)
        self.assertIs(obj,self.registry.resolve(newId))

    def test_register_with_id(self):
        obj = Foo()
        self.assertEqual(self.registry.register_with_id(obj, 'F123'),'F123')
        self.assertIs(obj,self.registry.resolve('F123'))

    def test_primitive_register(self):
        obj = Foo()
        self.registry._register(obj, 'F123')
        self.assertIn('F123', self.registry.idToObjMap)
        self.assertIn(id(obj), self.registry.objToIdMap)
    
    def test_clean(self):
        obj = Foo()
        self.registry._register(obj, 'F123')
        self.registry.clean('F123')
        self.assertNotIn('F123', self.registry.idToObjMap)
        self.assertNotIn(id(obj), self.registry.objToIdMap)

    def test_register_more_than_one(self):
        obj1 = Foo()
        obj2 = Foo()
        self.registry.register_with_id(obj1,'f1')
        self.registry.register_with_id(obj2,'f2')
        self.assertIs(obj2,self.registry.resolve('f2'))
        self.assertIs(obj1,self.registry.resolve('f1'))