
_command_pool = None

def set_pool(pool):
    global _command_pool
    _command_pool = pool

def get_pool():
    global _command_pool
    return _command_pool

