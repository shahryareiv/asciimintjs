import logging

VERBOSE = 1
NORMAL = 0
LESS_VERBOSE = -1
QUIET = -2

def logger(logname, level):
    loglevels = { QUIET:        logging.ERROR-1,
                  LESS_VERBOSE: logging.WARNING-1,
                  NORMAL:       logging.INFO-1,
                  VERBOSE:      logging.DEBUG-1 }

    log = logging.getLogger(logname)
    log.setLevel(loglevels[level])
    console = logging.StreamHandler()
    format = logging.Formatter("%(message)s")
    console.setFormatter(format)
    log.addHandler(console)
    return log

