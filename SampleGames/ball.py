import ServerEngine as se


canvas_size = [1000, 1600]


class BallGameInstance(se.BaseInstance):
    """
    Define the instance of each connection.
    """
    def setup_conn(self):
        # Initialize canvas
        se.Canvas(400, 600, instance=self)

        # Initialize the two balls
        se.Component(name='ball1', loc=(100, 500), shape='circle', 
                     texture='#ff0000', size=50, instance=self)
        se.Component(name='ball2', loc=(300, 100), shape='circle', 
                     texture='#00ff00', size=50, instance=self)

        # Send changes made to the client
        self.execute()

    def response_listener(self, response):
        print('instance listener triggered')
        print(response.target, response.operation, response.ax_data)

        # If ball 1 is clicked, make ball 2 larger and ball 1 smaller
        if response.operation == 'UPDATE':
            if response.target == 'ball1' and response.ax_data['action'] == 'click':
                print('Ball 1 clicked')
                self.components['ball2'].update(action='change_size', factor=1.3)
                self.components['ball1'].update(action='change_size', factor=0.7)

            # If ball 2 is clicked, make ball 1 larger and ball 2 smaller
            if response.target == 'ball2' and response.ax_data['action'] == 'click':
                print('Ball 2 clicked')
                self.components['ball1'].update(action='change_size', factor=1.3)
                self.components['ball2'].update(action='change_size', factor=0.7)
            
            # Send changes made to the client
            self.execute()


if __name__ == '__main__':
    # Initialize a game session and run it
    game = se.BaseGame(instance_class=BallGameInstance, port=8081)
    game.run()

