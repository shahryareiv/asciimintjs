# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
pdfLaTeX support for Rubber.

When this module loaded with the otion 'dvi', the document is compiled to DVI
using pdfTeX.

The module optimizes the pdflatex calls by setting -draftmode and apply a last
call to build the final PDF output.
"""
import os
import re
import subprocess
from subprocess import Popen, PIPE

from msg import _, msg
from plugins import TexModule


class Module (TexModule):
    def __init__ (self, doc, dict):
        self.doc = doc
        doc.program = "pdflatex"
        doc.engine = "pdfTeX"
        # FIXME: how to handle opt=dvi with file.tex passed?
        # FIXME: can we add commands after the file?
        doc.set_format("pdf")

        # Check the version to know if -draftmode is supported
        if (self._draft_is_supported()):
            self.doc.draft_support = True
        else:
            self.doc.draft_support = False
        #self.draft_support = False

    def _draft_is_supported(self):
        # FIXME: find a clean method to pass these options
        opts = os.getenv("DBLATEX_PDFTEX_OPTIONS", "")
        if not("-draftmode" in opts):
            return False
        return (self._get_version() == "1.40")

    def pre_compile(self):
        if not(self.doc.draft_support):
            return

        # Add -draftmode to prevent intermediate pdf output
        self.doc.opts.append("-draftmode")

    def last_compile(self):
        # If pdftex has no ability to work in draftmode, or if no final PDF
        # is required, do nothing
        if not(self.doc.draft_support) or self.doc.draft_only:
            return

        # Remove the -draftmode to have the PDF output, and compile again
        self.doc.opts.remove("-draftmode")
        rc = self.doc.compile()
        return rc

    def _get_version(self):
        """
        Parse something like:

          pdfTeX using libpoppler 3.141592-1.40.3-2.2 (Web2C 7.5.6)
          kpathsea version 3.5.6
          Copyright 2007 Peter Breitenlohner (eTeX)/Han The Thanh (pdfTeX).
          Kpathsea is copyright 2007 Karl Berry and Olaf Weber.
          ...
        and return '1.40'
        """
        # Grab the major version number
        p = Popen("pdflatex -version", shell=True, stdout=PIPE)
        data = p.communicate()[0]
        m = re.search("pdfTeX.*3.14[^-]*-(\d*.\d*)", data, re.M)
        if not(m):
            return ""
        else:
            return m.group(1)

