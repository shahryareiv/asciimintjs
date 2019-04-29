import os
from subprocess import Popen, PIPE

class Command:
    """Contains the needed data to run a command"""
    def __init__(self, args, stdin=None, stdout=None, shell=False):
        self.arguments = args
        self.stdin = stdin
        self.stdout = stdout
        self.shell = shell

class CommandRunner:
    """
    Execute the differents registered commands in the specified order,
    either independantly or as a pipe process chain if required
    """
    def __init__(self, module_name="", log=None):
        self.module_name = module_name
        self.commands = []
        self.processes = []
        self.log = log

    def info(self, text):
        if self.log: self.log.info(text)

    def set_name(self, module_name):
        self.module_name = module_name

    def add_command(self, args, stdin=None, stdout=None, shell=False):
        command = Command(args, stdin, stdout, shell)
        self.commands.append(command)
        return command

    def shcmd(self, args):
        nargs = []
        for arg in args:
            if len(arg.split()) > 1: arg = '"%s"' % arg
            nargs.append(arg)
        return " ".join(nargs)

    def run(self, kw=None):
        if not(self.commands):
            return
        if not(kw): kw = {}
        pipe_top = False
        rc = 0
        for cmd in self.commands:
            if rc != 0:
                break
            stdin, stdout = None, None
            prev_pipe = None
            if cmd.stdin == "PIPE":
                if self.processes:
                    prev_pipe = self.processes[-1]
                    stdin = prev_pipe.stdout
                else:
                    pipe_top = True
                    stdin = PIPE
            if cmd.stdout == "PIPE":
                stdout = PIPE
            elif cmd.stdout:
                stdout = open(cmd.stdout % kw, "w")

            if kw: args = [a % kw for a in cmd.arguments]
            else: args = cmd.arguments
            
            self.info(" ".join(args))
            # Some commands work only in shell env (e.g. links), so take care
            if cmd.shell:
                p = Popen(self.shcmd(args), stdin=stdin, stdout=stdout,
                          shell=True)
            else:
                p = Popen(args, stdin=stdin, stdout=stdout)
            self.processes.append(p)

            if stdin and prev_pipe:
                # Close stdout to allow <prev_pipe> receiving SIGPIPE
                prev_pipe.stdout.close()
            if stdout != PIPE:
                # Wait until the process is finished if not in a pipe chain
                rc = p.wait()
                if stdout: stdout.close()

        return rc

