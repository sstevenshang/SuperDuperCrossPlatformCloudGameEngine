import json
from ServerEngine.exception import InvalidResponse


class Command:
    def __init__(self, class_type, target, op, ax_data):
        self._class_type = class_type
        self._tgt        = target
        self._op         = op
        self._ax_data    = ax_data

    def as_dict(self):
        data_dict = {
            'class':     self._class_type,
            'target':    self._tgt,
            'operation': self._op,
            'ax_data':   self._ax_data
        }
        return data_dict


class Instruction:
    def __init__(self, cmds):
        self._commands = cmds

    def as_json(self):
        command_dicts = [cmd.as_dict() for cmd in self._commands]
        json_str = json.dumps(command_dicts)
        return json_str


class Response:
    def __init__(self, json_str):
        try:
            data_dict = json.loads(json_str)
        except:
            print('Unrecognized response')
            raise InvalidResponse()
        self.class_type = data_dict['class']
        self.target     = data_dict['target']
        self.operation  = data_dict['operation']
        self.ax_data    = data_dict['ax_data']

