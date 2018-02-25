import ServerEngine as se


canvas_size = [1000, 1600]


class BallGameInstance(se.BaseInstance):
    """
    Define the instance of each connection.
    """
    def setup_conn(self):
        # Initialize canvas
        self.canvas.create(canvas_size)

        # Initialize the two balls
        ball1 = se.Component(id_='ball1', loc=(20, 80), shape='circle', texture='#ff0000')
        ball2 = se.Component(id_='ball2', loc=(80, 20), shape='circle', texture='#00ff00')
        
        # Send changes made to the client
        self.execute()

    def response_listener(self, response):
        # If ball 1 is clicked, make ball 2 larger and ball 1 smaller
        if response.id_ == 'ball1' and response.action == 'click':
            ball2.update(action='change_size', factor=1.1)
            ball1.update(action='change_size', factor=0.9)

        # If ball 2 is clicked, make ball 1 larger and ball 2 smaller
        if response.id_ == 'ball2' and response.action == 'click':
            ball1.update(action='change_size', factor=1.1)
            ball2.update(action='change_size', factor=0.9)
        
        # Send changes made to the client
        self.execute()


if __name__ == '__main__':
    # Initialize a game session and run it
    game = se.BaseGame(instance_class=BallGameInstance)
    game.run()

