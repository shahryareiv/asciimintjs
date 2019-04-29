# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
PostScript generation through dvips with Rubber.

This module has specific support for Omega: when the name of the main compiler
is "Omega" (instead of "TeX" for instance), then "odvips" is used instead of
"dvips".
"""

import sys
import os
from os.path import *
import subprocess

from msg import _ , msg
from plugins import TexModule
from maker import Depend

class Dep (Depend):
    def __init__ (self, doc, target, source, node):
        self.doc = doc
        self.env = doc.env
        self.source = source
        self.target = target
        Depend.__init__(self, doc.env, prods=[target], sources={source: node})
        self.options = []
        if self.doc.engine == "Omega":
            self.cmdexec = "odvips"
        else:
            self.cmdexec = "dvips"
            self.options.append("-R0")

    def run (self):
        cmd = [self.cmdexec]
        msg.progress(_("running %s on %s") % (cmd[0], self.source))
        for opt in self.doc.paper.split():
            cmd.extend(["-t", opt])
        cmd.extend(self.options + ["-o", self.target, self.source])
        msg.debug(" ".join(cmd))
        rc = subprocess.call(cmd, stdout=msg.stdout)
        if rc != 0:
            msg.error(_("%s failed on %s") % (cmd[0], self.source))
            return 1
        return 0

class Module (TexModule):
    def __init__ (self, doc, dict):
        self.doc = doc
        lastdep = doc.env.dep_last()
        dvi = lastdep.prods[0]
        root, ext = os.path.splitext(dvi)
        if ext != ".dvi":
            msg.error(_("I can't use dvips when not producing a DVI"))
            sys.exit(2)
        ps = root + ".ps"
        self.dep = Dep(doc, ps, dvi, lastdep)
        doc.env.dep_append(self.dep)

    def do_options (self, *args):
        self.dep.options.extend(args)

