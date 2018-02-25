import socket, select

class Server:
    _host_name = None
    _port = None
    _on_connect_k = None
    _on_response_k = None
    _connections = None

    def __init__(self, host_name, port, on_connect_k, on_response_k):
        self._host_name = host_name
        self._port = port
        self._on_connect_k = on_connect_k
        self._on_response_k = on_response_k
        self._connections = {}


    def run_server(self):
        serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        serversocket.bind((self._host_name, self._port))
        serversocket.listen(1)
        serversocket.setblocking(0)

        epoll = select.epoll()
        epoll.register(serversocket.fileno(), select.EPOLLIN | select.EPOLLET)

        try:
           while True:
              events = epoll.poll(maxevents = 1)
              print(events)
              for fileno, event in events:
                 if fileno == serversocket.fileno():
                    try:
                        connection, address = serversocket.accept()
                        connection.setblocking(0)
                        epoll.register(connection.fileno(), select.EPOLLIN | select.EPOLLET)
                        self._connections[connection.fileno()] = connection

                        # Invoke the callback on_connect_k
                        self._on_connect_k(connection.fileno())

                    except socket.error:
                       pass
                 elif event & select.EPOLLIN:
                    try:
                        data = self._connections[fileno].recv(1024)
                        if len(data) != 0:
                            print('========================')
                            print(str(data, "utf-8"))
                            print('========================')
                            # dummy_data = '{"class":"CANVAS","target":"","operation": "CREATE","ax_data":{"size": [800, 1200]}}'
                            # self._connections[fileno].sendall(bytes(dummy_data,'utf-8'))
                            data_str = str(data, 'utf-8')
                            self._on_response_k(fileno, data_str)
                        else:
                            epoll.unregister(fileno)
                            self._connections[fileno].close()
                            del self._connections[fileno]
                    except socket.error:
                       pass
                 elif event & select.EPOLLHUP:
                    epoll.unregister(fileno)
                    self._connections[fileno].close()
                    del self._connections[fileno]
        finally:
           epoll.unregister(serversocket.fileno())
           epoll.close()
           serversocket.close()

    def send_message(self, user_id, message):
        self._connections[user_id].sendall(bytes(message,'utf-8'))
