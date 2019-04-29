#
# Wrapper for xslt an engine command specified by an XML Configuration.
#
import os
import re
import logging
from subprocess import call, Popen, PIPE
from dbtexmf.core.commander import CommandRunner
from dbtexmf.core.error import signal_error
import dbtexmf.xslt

class XsltEngine:
    _log = logging.getLogger("dblatex")

    def __init__(self, param_format=""):
        self.param_format = param_format
        self.subcommand_with_params = None
        self.command = CommandRunner(log=self._log)

    def add_command(self, *args, **kwargs):
        # Remember the subcommand that shall contain XSL parameters
        sc = self.command.add_command(*args, **kwargs)
        if "%(param_list)s" in args[0]:
            self.subcommand_with_params = sc

    def _run(self, xslfile, xmlfile, outfile):
        rc = self.command.run(kw={"stylesheet": xslfile,
                                  "xmlfile": xmlfile,
                                  "output": outfile })
        if rc != 0: signal_error(self, "")

    def run(self, xslfile, xmlfile, outfile, opts=None, params=None):
        if not(self.subcommand_with_params):
            self._run(xslfile, xmlfile, outfile)
        else:
            # Temporary replace the parameter list in the command
            args_pattern = self.subcommand_with_params.arguments
            self.subcommand_with_params.arguments = \
                self.param_args_format(args_pattern, params)
            self._run(xslfile, xmlfile, outfile)
            self.subcommand_with_params.arguments = args_pattern

    def param_args_format(self, arguments, params):
        args = [] + arguments
        idx = args.index("%(param_list)s")
        args.remove("%(param_list)s")

        if not(params):
            return args
        if not(self.param_format):
            self._log.error("Error: Unknown XSL Parameter format")
            return args

        param_args = []
        for param, value in params.items():
            param_args.append(self.param_format % {"param_name": param,
                                                   "param_value": value})

        for i in range(0, len(param_args)):
            args.insert(idx+i, param_args[i])

        return args

class XsltCommandPool:
    def __init__(self):
        self.command_runs = []

    def add_command_run(self, command_runner):
        self.command_runs.append(command_runner)

    def extend(self, other):
        self.command_runs.extend(other.command_runs)

    def prepend(self, other):
        self.command_runs = other.command_runs + self.command_runs

    def get_command_runs(self, **criterions):
        # By default return all the items
        founds = [] + self.command_runs
        return founds


class XsltConfigRunner:
    """
    Module loaded when a user defined XSLT engine is run. It just selects
    the first engine from the pool, and run it.
    """
    def __init__(self):
        pool = dbtexmf.xslt.get_pool()
        if pool:
            commands = pool.get_command_runs()
            if commands: self.command = commands[0]
        else:
            self.command = None

    def get_deplist(self):
        return []

    def run(self, xslfile, xmlfile, outfile, opts=None, params=None):
        if not(self.command):
            raise ValueError("xsltconf: no command found")

        self.command.run(xslfile, xmlfile, outfile,
                         opts=opts, params=params)


class Xslt(XsltConfigRunner):
    "Plugin Class to load"
