from comm import Command
from exceptions import *

class Component:
    def __init__(self, instance, name, loc, shape, size, texture):
        self._instance = instance
        self._id = name
        self._loc = loc
        self._shape = shape
        self._size = size
        self._texture = texture
        
        # Check parameter format
        if shape == 'circle':
            if type(size) != int:
                raise ConfigError('Wrong parameter for constructing a circle')
        if shape == 'rectangle':
            if type(size) != list or len(size) != 2 or min(size) < 0:
                raise ConfigError('Wrong parameter for constructing a rectangle')
        loc = list(loc)

        # Initialize history
        init_cmd = Command('COMPONENT', name, 'INIT',
                {loc: loc, shape: shape, texture: texture, size: size})
        self._instance.add_hist_entry(init_cmd)


    def update(self, action, texture=None, factor=None, loc=None):
        if action == 'move':
            if not ((type(loc) == list or type(loc) == tuple) and len(loc) == 2):
                raise ConfigError('Wrong parameter for action `move`')
            self._loc = list(loc)
            cmd = Command('COMPONENT', self._id, 'UPDATE', {'loc': loc})

        elif action == 'change_size':
            try:
                factor = float(factor)
            except TypeError:
                raise ConfigError('Wrong parameter for action `change_size`')
            cmd = Command('COMPONENT', self._id, 'UPDATE', {'factor': factor})
        
        elif action == 'change_texture':
            if type(texture) != str:
                raise ConfigError('Wrong parameter for action `change_texture`')
            cmd = Command('COMPONENT', self._id, 'UPDATE', {'texture': texture})
        
        else:
            raise ConfigError('Unsupported action `%s`' % action)

        self._instance.add_hist_entry(cmd)

