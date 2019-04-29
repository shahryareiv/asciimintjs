# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
LaTeX document building system for Rubber.

This module contains all the code in Rubber that actually does the job of
building a LaTeX document from start to finish.
"""
import os
import sys
import time
import subprocess

from msg import _, msg
from util import Watcher
from logparser import LogParser
from texparser import TexParser
from plugins import Modules
from maker import Depend


class Latex(Depend):
    def __init__(self, maker):
        Depend.__init__(self, maker)
        self.logfile = None
        self.auxfile = None
        self.srcfile = None
        self.srcbase = None
        self.outfile = None
        self.program = "latex"
        self.engine = "TeX"
        self.paper = ""
        self.prods = []
        self.must_compile = 0
        self.something_done = 0
        self.failed_module = None
        self.watcher = Watcher()
        self.log = LogParser()
        self.modules = Modules(self)
        self.parser = TexParser(self)
        self.date = None
        # Is the final output expected?
        self.draft_only = False
        self.draft_support = False
        self.batch = 1
        self.opts = []

    def reinit(self):
        # Restart with a clean module set, parser and logger
        self.__init__(self.env)

    def set_source(self, input):
        self.srcfile = os.path.realpath(input)
        self.srcbase = os.path.splitext(self.srcfile)[0]
        self.src_base = self.srcbase
        self.logfile = self.srcbase + ".log"
        self.auxfile = self.srcbase + ".aux"
        self.set_format("dvi")

    def set_format(self, format):
        self.outfile = self.srcbase + "." + format
        self.prods = [self.outfile]

    def compile_needed (self):
        """
        Returns true if a first compilation is needed. This method supposes
        that no compilation was done (by the script) yet.
        """
        if self.must_compile:
            return 1
        msg.log(_("checking if compiling is necessary..."))
        if not self.draft_support and not os.path.exists(self.outfile):
            msg.debug(_("the output file doesn't exist"))
            return 1
        if not os.path.exists(self.logfile):
            msg.debug(_("the log file does not exist"))
            return 1
        if (not self.draft_support and 
            (os.path.getmtime(self.outfile) < os.path.getmtime(self.srcfile))):
            msg.debug(_("the source is younger than the output file"))
            return 1
        if self.log.read(self.logfile):
            msg.debug(_("the log file is not produced by TeX"))
            return 1
        return self.recompile_needed()

    def recompile_needed (self):
        """
        Returns true if another compilation is needed. This method is used
        when a compilation has already been done.
        """
        changed = self.watcher.update()
        if self.must_compile:
            return 1
        if self.log.errors():
            msg.debug(_("last compilation failed"))
            return 1
#        if self.deps_modified(os.path.getmtime(self.outfile)):
#            msg.debug(_("dependencies were modified"))
#            return 1
        if changed and (len(changed) > 1 or changed[0] != self.auxfile):
            msg.debug(_("the %s file has changed") % changed[0])
            return 1
        if self.log.run_needed():
            msg.debug(_("LaTeX asks to run again"))
            if (not(changed)):
                msg.debug(_("but the aux files are unchanged"))
                return 0
            return 1
        if changed:
            msg.debug(_("the %s file has changed but no re-run required?") \
                      % changed[0])
            if self.program == "xelatex":
                msg.debug(_("force recompilation (XeTeX engine)"))
                return 1

        msg.debug(_("no new compilation is needed"))
        return 0

    def prepare(self, exclude_mods=None):
        """
        Prepare the compilation by parsing the source file. The parsing
        loads all the necessary modules required by the packages used, etc.
        """
        f = open(self.srcfile)
        self.parser.parse(f, exclude_mods=exclude_mods)
        f.close()

    def force_run(self):
        self.run(force=1)

    def run(self, force=0):
        """
        Run the building process until the last compilation, or stop on error.
        This method supposes that the inputs were parsed to register packages
        and that the LaTeX source is ready. If the second (optional) argument
        is true, then at least one compilation is done. As specified by the
        class Depend, the method returns 0 on success and 1 on failure.
        """
        if self.pre_compile(force):
            return 1

        # If an error occurs after this point, it will be while LaTeXing.
        self.failed_dep = self
        self.failed_module = None

        if self.batch:
            self.opts.append("-interaction=batchmode")

        need_compile = force or self.compile_needed()
        while need_compile:
            if self.compile(): return 1
            if self.post_compile(): return 1
            need_compile = self.recompile_needed()

        # Finally there was no error.
        self.failed_dep = None

        if self.last_compile():
            return 1

        if self.something_done:
            self.date = int(time.time())
        return 0

    def pre_compile(self, force):
        """
        Prepare the source for compilation using package-specific functions.
        This function must return true on failure. This function sets
        `must_compile' to 1 if we already know that a compilation is needed,
        because it may avoid some unnecessary preprocessing (e.g. BibTeXing).
        """
        # Watch for the changes of these working files
        for ext in ("aux", "toc", "lot", "lof"):
            self.watcher.watch(self.srcbase + "." + ext)

        msg.log(_("building additional files..."))
        for mod in self.modules.objects.values():
            if mod.pre_compile():
                self.failed_module = mod
                return 1
        return 0

    def post_compile(self):
        """
        Run the package-specific operations that are to be performed after
        each compilation of the main source. Returns true on failure.
        """
        msg.log(_("running post-compilation scripts..."))

        for mod in self.modules.objects.values():
            if mod.post_compile():
                self.failed_module = mod
                return 1
        return 0

    def last_compile(self):
        """
        Run the module-specific operations that are to be performed after
        the last compilation of the main source. Returns true on failure.
        """
        msg.log(_("running last-compilation scripts..."))

        for mod in self.modules.objects.values():
            if mod.last_compile():
                self.failed_module = mod
                return 1
        return 0

    def compile(self):
        self.must_compile = 0
        cmd = [self.program] + self.opts + [os.path.basename(self.srcfile)]
        msg.log(" ".join(cmd))
        rc = subprocess.call(cmd, stdout=msg.stdout)
        if rc != 0:
            msg.error(_("%s failed") % self.program)
        # Whatever the result is, read the log file
        if self.log.read(self.logfile):
            msg.error(_("Could not run %s.") % self.program)
            return 1
        if self.log.errors():
            return 1
        return rc

    def clean(self):
        """
        Remove all files that are produced by compilation.
        """
        self.remove_suffixes([".log", ".aux", ".toc", ".lof", ".lot",
                              ".out", ".glo", ".cb"])

        msg.log(_("cleaning additional files..."))
        # for dep in self.sources.values():
        #     dep.clean()

        for mod in self.modules.objects.values():
            mod.clean()

    def remove_suffixes (self, list):
        """
        Remove all files derived from the main source with one of the
        specified suffixes.
        """
        for suffix in list:
            file = self.src_base + suffix
            if os.path.exists(file):
                msg.log(_("removing %s") % file)
                os.unlink(file)

    def get_errors (self):
        if not(self.failed_module):
            return self.log.get_errors()
        else:
            return self.failed_module.get_errors()

    def print_misschars(self):
        """
        Sort the characters not handled by the selected font,
        and print them as a warning.
        """
        missed_chars = []
        for c in self.log.get_misschars():
            missed_chars.append((c["uchar"], c["font"]))
        # Strip redundant missed chars
        missed_chars = list(set(missed_chars))
        missed_chars.sort()
        for m in missed_chars:
            # The log file is encoded in UTF8 (xetex) or in latin1 (pdftex)
            try:
                uchar = m[0].decode("utf8")
            except:
                uchar = m[0].decode("latin1")
            # Check we have a real char (e.g. not something like '^^a3')
            if len(uchar) == 1:
                msg.warn("Character U+%X (%s) not in font '%s'" % \
                         (ord(uchar), m[0], m[1]))
            else:
                msg.warn("Character '%s' not in font '%s'" % (m[0], m[1]))

