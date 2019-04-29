# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
Dependency analysis for the xr package.

The xr package allows one to put references in one document to other
(external) LaTeX documents. It works by reading the external document's .aux
file, so this support package registers these files as dependencies.
"""
import os

from msg import _, msg
from plugins import TexModule
from latex import Latex

class Module(TexModule):
    def __init__ (self, doc, dict):
        # <doc> is the main Latex() document to compile
        # <env> is the maker engine
        self.doc = doc
        self.env = doc.env

        # remember the engine used to build the main latex document
        self.texmodules = []
        for m in ("pdftex", "xetex"):
            if doc.modules.has_key(m):
                self.texmodules.append(m)

        # want to track each external document whose .aux is required
        doc.parser.add_hook("externaldocument", self.externaldocument)

    def externaldocument (self, dict):
        # .aux document needed to cross-ref with xr
        auxfile = dict["arg"] + ".aux"
        texfile = dict["arg"] + ".tex"

        # Ignore the dependency if no tex source found
        if not(os.path.isfile(texfile)):
            msg.log(_("file %s is required by xr package but not found")\
                    % texfile, pkg="xr")
            return

        # Ask to compile the related .tex file to have the .aux 
        texdep = Latex(self.env)
        texdep.set_source(texfile)
        texdep.batch = self.doc.batch
        texdep.encoding = self.doc.encoding
        texdep.draft_only = True # Final output not required here
        for m in self.texmodules:
            texdep.modules.register(m)
        # Load other modules from source, except xr to avoid loops
        texdep.prepare(exclude_mods=["xr-hyper"])

        # Add the .aux as an expected input for compiling the doc
        self.doc.sources[auxfile] = texdep
        msg.log(_(
            "dependency %s added for external references") % auxfile, pkg="xr")
