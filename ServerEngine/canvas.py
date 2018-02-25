class Canvas:
    def __init__(self, instance, width, height):
        self._instance = instance
        self._width = width
        self._height = height
        init_cmd = Command('CANVAS', '', 'CREATE', {'size': [width, height]})
        instance.add_hist_entry(init_cmd)
