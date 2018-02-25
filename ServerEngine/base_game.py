from ServerEngine.server import Server
from threading import Thread

class BaseGame:
    def __init__(self, instance_class, host='', port=8080):
        self._instance_class = instance_class
        self._server = Server(host, port, self.on_connect, self.on_response)
        self._users = {}

    def run(self):
        def work():
            self._server.run_server()
        t = Thread(target=work, args=())
        t.start()

    def on_connect(self, user_id):
        print('+++++++++++++++++')
        print('On connect: %s' % str(user_id))
        print('+++++++++++++++++')
        user_inst = self._instance_class(self, user_id)
        user_inst.setup_conn()
        self._users[user_id] = user_inst

    def on_response(self, user_id, message):
        user_inst = self._users[user_id]
        user_inst.feed_response(message)

    def send_message(self, user_id, message):
        self._server.send_message(user_id, message)

