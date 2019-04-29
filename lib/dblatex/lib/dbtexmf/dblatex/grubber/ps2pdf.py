# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2004--2006
"""
PostScript to PDF conversion using GhostScript.
"""

import sys
import os

from msg import _, msg
from maker import DependShell
from plugins import TexModule


class Module (TexModule):
    def __init__ (self, doc, dict):
        env = doc.env
        ps = env.dep_last().prods[0]
        root, ext = os.path.splitext(ps)
        if ext != ".ps":
            msg.error(_("I can't use ps2pdf when not producing a PS"))
            sys.exit(2)
        pdf = root + ".pdf"
        cmd = ["ps2pdf"]
        for opt in doc.paper.split():
            cmd.append("-sPAPERSIZE=" + opt)
        cmd.extend([ps, pdf])
        dep = DependShell(env, cmd, prods=[pdf], sources={ ps: env.dep_last() })
        env.dep_append(dep)

