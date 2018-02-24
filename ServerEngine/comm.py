import json


class Command:
    def __init__(self, class_type, tgt, op, ax_data):
        self._class_type = class_type
        self._tgt        = tgt
        self._op         = op
        self._ax_data    = ax_data

    def _to_json(self):
        data_dict = {
            'class':     self._class_type,
            'target':    self._tgt,
            'operation': self._op,
            'ax_data':   self._ax_data
        }
        json_str = json.dumps(data_dict)
        return json_str
