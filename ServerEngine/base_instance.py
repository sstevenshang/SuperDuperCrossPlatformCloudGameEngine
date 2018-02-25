from ServerEngine.comm import Instruction, Response

class BaseInstance:
    def __init__(self, game, user_id):
        self._history = []
        self._game = game
        self._user_id = user_id
        self.canvas = None
        self.components = {}

    def add_hist_entry(self, cmd):
        self._history.append(cmd)

    def execute(self):
        inst = Instruction(self._history)
        message = inst.as_json()
        self._game.send_message(self._user_id, message)
        self._history = []

    def feed_response(self, message):
        try:
            resp = Response(message)
        except InvalidResponse as e:
            return
        self.response_listener(resp)

