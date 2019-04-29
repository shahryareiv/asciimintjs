#
# Dblatex parser. Its role is to:
# - encode the raw tex file to the expected output encoding, taking care about
#   the special characters to escape,
# - convert the document images to the appropriate format if needed
#
import sys
import os
import re

from rawparse import RawLatexParser, RawUtfParser
from rawverb import VerbParser
from xetex.codec import XetexCodec
from dbtexmf.core.imagedata import *


class RawLatex:
    "Main latex file parser"
    def __init__(self):
        self.figre = \
            re.compile(r"(\\includegraphics[\[]?|"\
                       r"\\begin{overpic}|"\
                       r"\\imgexits)[^{]*{([^}]*)}")
        self.image = Imagedata()
        self.parsers = []
        self.format = None
        self.backend = None

    def set_fig_paths(self, paths):
        self.image.paths = paths

    def set_parsers(self, input, output_encoding=""):
        codec = None
        if self.backend == "xetex":
            output_encoding = "utf8"
            codec = XetexCodec()
        elif not(output_encoding):
            f = file(input)
            params = {}
            started = 0
            for line in f:
                if not(started):
                    if line.startswith("%%<params>"): started = 1
                    continue
                if line.startswith("%%</params>"):
                    break
                p = line.split()
                params[p[1]] = p[2]
            output_encoding = params.get("latex.encoding", "latin-1")

        self.parsers = [VerbParser(output_encoding=output_encoding),
                        RawLatexParser(codec=codec,
                                       output_encoding=output_encoding),
                        RawUtfParser(output_encoding=output_encoding)]
        self.image.set_encoding(output_encoding or "latin-1")

    def set_format(self, format, backend=None):
        # Adjust the actual format from backend
        if (format == "pdf" and backend == "dvips"):
            format = "ps"
        self.format = format
        self.backend = backend
        self.image.set_format(format, backend)

    def fig_format(self, format):
        # TODO: consistency check?
        self.image.input_format = format

    def parse(self, input, output):
        self.set_parsers(input)
        f = file(input)
        o = file(output, "w")
        for line in f:
            if self.format:
                line = self.figconvert(line)
            for p in self.parsers:
                line = p.parse(line)
                if not(line):
                    break
            if line:
                o.write(line)
        o.close()
        f.close()

    def figconvert(self, line):
        # Is there one or more images included here
        mlist = self.figre.findall(line)
        if not(mlist):
            return line

        # Try to convert each found image
        for m in mlist:
            fig = m[1]
            newfig = self.image.convert(fig)

            # If something done, replace the figure in the tex file
            if newfig != fig:
                line = re.sub(r"{%s}" % fig, r"{%s}" % newfig, line)

        return line
            

def main():
    c = RawLatex()
    c.set_fig_paths([os.getcwd()])
    c.parse(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
    main()
