import json
#from time import time


class Command:
    def __init__(self, class_type, target, op, ax_data):
        self._class_type = class_type
        self._tgt        = target
        self._op         = op
        self._ax_data    = ax_data
        #self.timestamp   = time()

    def as_dict(self):
        data_dict = {
            'class':     self._class_type,
            'target':    self._tgt,
            'operation': self._op,
            'ax_data':   self._ax_data
        }
        return data_dict


class Instruction:
    def __init__(self):
        self.commands = []

    def add_command(self, command):
        self.commands.append(command)

    def as_json(self):
        command_dicts = [cmd.as_dict() for cmd in self.commands]
        json_str = json.dumps(command_dicts)
        return json_str


class Response:
    def __init__(self, json_str):
        data_dict = json.loads(json_str)
        self.class_type = data_dict['class']
        self.target     = data_dict['target']
        self.action     = data_dict['operation']
        self.ax_data    = data_dict['ax_data']

