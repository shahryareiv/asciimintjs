# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
This module defines the messages diplay class, and creates the application-wide
msg object.
"""
import os, os.path
import sys
import logging

def _(txt): return txt

class Message (object):
    """
    All messages in the program are output using the `msg' object in the
    main package. This class defines the interface for this object.
    """
    def __init__ (self, level=1, write=None):
        """
        Initialize the object with the specified verbosity level and an
        optional writing function. If no such function is specified, no
        message will be output until the 'write' field is changed.
        """
        self.level = level
        self.write = self.write_stdout
        if write:
            self.write = write
        self.short = 0
        self.path = ""
        self.cwd = "./"
        self.pos = []
        self._log = logging.getLogger("dblatex")
        level = self._log.getEffectiveLevel()
        if level >= logging.WARNING:
            self.stdout = open(os.devnull, "w")
        else:
            self.stdout = None

    def write_stdout(self, text, level=0):
        print text
    def write_stderr(self, text, level=0):
        print >>sys.stderr, text

    def push_pos (self, pos):
        self.pos.append(pos)
    def pop_pos (self):
        del self.pos[-1]

    def __call__ (self, level, text):
        """
        This is the low level printing function, it receives a line of text
        with an associated verbosity level, so that output can be filtered
        depending on command-line options.
        """
        if self.write and level <= self.level:
            self.write(text, level=level)

    def display (self, kind, text, **info):
        """
        Print an error or warning message. The argument 'kind' indicates the
        kind of message, among "error", "warning", "abort", the argument
        'text' is the main text of the message, the other arguments provide
        additional information, including the location of the error.
        """
        if kind == "error":
            if text[0:13] == "LaTeX Error: ":
                text = text[13:]
            self._log.error(self.format_pos(info, text))
            if info.has_key("code") and info["code"] and not self.short:
                self._log.error(self.format_pos(info,
                    _("leading text: ") + info["code"]))

        elif kind == "abort":
            if self.short:
                msg = _("compilation aborted ") + info["why"]
            else:
                msg = _("compilation aborted: %s %s") % (text, info["why"])
            self._log.error(self.format_pos(info, msg))

#        elif kind == "warning":
#            self._log.warning(self.format_pos(info, text))

    def error (self, text, **info):
        self.display(kind="error", text=text, **info)
    def warn (self, what, **where):
        self._log.warning(self.format_pos(where, what))
    def progress (self, what, **where):
        self._log.info(self.format_pos(where, what + "..."))
    def info (self, what, **where):
        self._log.info(self.format_pos(where, what))
    def log (self, what, **where):
        self._log.debug(self.format_pos(where, what))
    def debug (self, what, **where):
        self._log.debug(self.format_pos(where, what))

    def format_pos (self, where, text):
        """
        Format the given text into a proper error message, with file and line
        information in the standard format. Position information is taken from
        the dictionary given as first argument.
        """
        if len(self.pos) > 0:
            if where is None or not where.has_key("file"):
                where = self.pos[-1]
        elif where is None or where == {}:
            return text

        if where.has_key("file") and where["file"] is not None:
            pos = self.simplify(where["file"])
            if where.has_key("line") and where["line"]:
                pos = "%s:%d" % (pos, int(where["line"]))
                if where.has_key("last"):
                    if where["last"] != where["line"]:
                        pos = "%s-%d" % (pos, int(where["last"]))
            pos = pos + ": "
        else:
            pos = ""
        if where.has_key("page"):
            text = "%s (page %d)" % (text, int(where["page"]))
        if where.has_key("pkg"):
            text = "[%s] %s" % (where["pkg"], text)
        return pos + text

    def simplify (self, name):
        """
        Simplify an path name by removing the current directory if the
        specified path is in a subdirectory.
        """
        path = os.path.normpath(os.path.join(self.path, name))
        if path[:len(self.cwd)] == self.cwd:
            return path[len(self.cwd):]
        return path

    def display_all (self, generator, writer=None):
        if writer:
            write = self.write
            self.write = writer
        something = 0
        for msg in generator:
            self.display(**msg)
            something = 1
        if writer:
            self.write = write
        return something

msg = Message()

