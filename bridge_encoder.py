import json
import io

class BridgeEncoder(json.JSONEncoder):
    def __init__(self, *args, **kwargs):
        json.JSONEncoder.__init__(self, *args, **kwargs)
        self.mapper = self.default_mapper()

    def default_mapper(self):
        d = {}
        return d

    def default(self, obj):
        if type(obj) in self.mapper:
            return mapper[type(obj)](obj)
        return {
            '__pyclass__': type(obj).__name__,
            '__pyid__': 334
            }