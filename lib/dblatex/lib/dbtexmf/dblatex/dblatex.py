#
# DbLatex main class handling the compilation of a DocBook file via
# XSL Transformation and LaTeX compilation.
#
import os

from dbtexmf.core.sgmlxml import Osx
from dbtexmf.core.dbtex import DbTex, DbTexCommand

from rawtex import RawLatex
from runtex import RunLatex


class DbLatex(DbTex):

    def __init__(self, base=""):
        DbTex.__init__(self, base=base)
        self.name = "dblatex"

        # Engines to use
        self.runtex = RunLatex()
        self.runtex.index_style = os.path.join(self.topdir,
                                               "latex", "scripts", "doc.ist")
        self.rawtex = RawLatex()
        self.sgmlxml = Osx()

    def set_base(self, topdir):
        DbTex.set_base(self, topdir)
        self.xslmain = os.path.join(self.topdir, "xsl", "latex_book_fast.xsl")
        self.xsllist = os.path.join(self.topdir,
                                    "xsl", "common", "mklistings.xsl")
        self.texdir = os.path.join(self.topdir, "latex")
        self.texlocal = os.path.join(self.topdir, "latex", "style")
        self.confdir = os.path.join(self.topdir, "latex", "specs")


#
# Command entry point
#
def main(base=""):
    command = DbTexCommand(base)
    command.run = DbLatex(base=base)
    command.main()

if __name__ == "__main__":
    main()
