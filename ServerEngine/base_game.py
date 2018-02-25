from server import Server
from threading import Thread

class BaseGame:
    def __init__(self, instance_class, host='', port=8080):
        self._instance_class = instance_lass
        self._server = Server(host, port, self.on_connect, self.on_response)
        self._users = {}

    def run(self):
        t = Thread(target=lambda _: self._server.run(), args=())
        t.start()

    def on_connect(self, user_id):
        self._users[user_id] = self._instance_class(self, user_id)

    def on_response(self, user_id, message):
        user_inst = self._users[user_id]
        user_inst.feed_response(message)

    def send_command(self, user_id, message):
        self._server.send_message(user_id, message)

