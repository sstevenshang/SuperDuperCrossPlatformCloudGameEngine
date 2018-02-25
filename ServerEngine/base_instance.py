class BaseInstance:
    def __init__(self, game, user_id):
        self._history = []

    def add_hist_entry(self, cmd):
        self._history.append(cmd)

    def execute():
        inst = Instruction(cmds)
        message = inst.as_json()
        # TODO: write to user
        self._history = []
