import bridge_globals
from uuid import uuid1

def ensure_global_registry():
    bridge_globals.ObjectRegistry = Registry()

def registry():
    return bridge_globals.ObjectRegistry

class Registry():

    def __init__(self):
        self.idToObjMap = {}
        self.objToIdMap = {}

    def createNewObjId(self):
        return uuid1().hex
    
    def register(self, obj):
        if id(obj) in self.objToIdMap:
            return self.objToIdMap[id(obj)]
        else:
            return self._register(obj, self.createNewObjId())
    
    def register_with_id(self, obj, newObjId):
        if id(obj) in self.objToIdMap:
            objId = self.objToIdMap[id(obj)]
            if objId == id:
                return id
            else:
                raise RegistryError
        else:
            return self._register(obj, newObjId)

    def resolve(self, objId):
        if objId in self.idToObjMap:
            return self.idToObjMap[objId]
        else:
            raise RegistryError

    def _register(self, obj, newObjId):
        self.idToObjMap[newObjId] = obj
        self.objToIdMap[id(obj)] = newObjId
        return newObjId

    def clean(self, objId):
        obj = self.idToObjMap[objId]
        del self.idToObjMap[objId]
        del self.objToIdMap[id(obj)]

class RegistryError(Exception):
    """Base class for exceptions in this module."""
    pass