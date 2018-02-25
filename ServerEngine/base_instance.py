from comm import Instruction, Response

class BaseInstance:
    def __init__(self, game, user_id):
        self._history = []
        self._game = game
        self._user_id = user_id

    def add_hist_entry(self, cmd):
        self._history.append(cmd)

    def execute(self):
        inst = Instruction(cmds)
        message = inst.as_json()
        self._game.send_message(self._user_id, message)
        self._history = []

    def feed_response(self, message):
        resp = Response(message)
        self.response_listener(resp)

