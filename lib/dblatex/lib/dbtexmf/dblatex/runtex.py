#
# Basic module compiling a file with LaTeX
#
import os
import re
import shutil

from grubber.texbuilder import LatexBuilder


class RunLatex:
    def __init__(self):
        self.fig_paths = []
        self.index_style = ""
        self.backend = "pdftex"
        self.texpost = ""
        self.texer = LatexBuilder()

    def set_fig_paths(self, paths):
        # Assume the paths are already absolute
        if not(paths):
            return

        # Use TEXINPUTS to handle paths containing spaces
        paths_blank = []
        paths_input = []
        for p in paths:
            if p.find(" ") != -1:
                paths_blank.append(p + "//")
            else:
                paths_input.append(p)

        if paths_blank:
            texinputs = os.pathsep.join(paths_blank)
            os.environ["TEXINPUTS"] = os.getenv("TEXINPUTS") + os.pathsep + \
                                      texinputs

        paths = paths_input

        # Unixify the paths when under Windows
        if os.sep != "/":
            paths = [p.replace(os.sep, "/") for p in paths]

        # Protect from tilde active char (maybe others?)
        self.fig_paths = [p.replace("~", r"\string~") for p in paths]

    def set_bib_paths(self, bibpaths, bstpaths=None):
        # Just set BIBINPUTS and/or BSTINPUTS
        if bibpaths:
            os.environ["BIBINPUTS"] = os.pathsep.join(bibpaths +
                                                   [os.getenv("BIBINPUTS", "")])
        if bstpaths:
            os.environ["BSTINPUTS"] = os.pathsep.join(bstpaths +
                                                   [os.getenv("BSTINPUTS", "")])

    def set_backend(self, backend):
        if not(backend in ("dvips", "pdftex", "xetex")):
            raise ValueError("'%s': invalid backend" % backend)
        self.backend = backend

    def get_backend(self):
        return self.backend

    def _clear_params(self):
        self._param_started = 0
        self._param_ended = 0
        self._params = {}

    def _set_params(self, line):
        # FIXME
        if self._param_ended:
            return
        if not(self._param_started):
            if line.startswith("%%<params>"): self._param_started = 1
            return
        if line.startswith("%%</params>"):
            self._param_ended = 1
            return
        # Expected format is: '%% <param_name> <param_string>\n'
        p = line.split(" ", 2)
        self._params[p[1]] = p[2].strip()

    def compile(self, texfile, binfile, format, batch=1):
        root = os.path.splitext(texfile)[0]
        tmptex = root + "_tmp" + ".tex"
        texout = root + "." + format

        # The temporary file contains the extra paths
        f = file(tmptex, "w")
        if self.fig_paths:
            paths = "{" + "//}{".join(self.fig_paths) + "//}"
            f.write("\\makeatletter\n")
            f.write("\\def\\input@path{%s}\n" % paths)
            f.write("\\makeatother\n")

        # Copy the original file and collect parameters embedded in the tex file
        self._clear_params()
        input = file(texfile)
        for line in input:
            self._set_params(line)
            f.write(line)
        f.close()
        input.close()

        # Replace the original file with the new one
        shutil.move(tmptex, texfile)

        # Build the output file
        try:
            self.texer.batch = batch
            self.texer.texpost = self.texpost
            self.texer.encoding = self._params.get("latex.encoding", "latin-1")
            self.texer.options = self._params.get("latex.engine.options")
            self.texer.lang = self._params.get("document.language")
            self.texer.set_format(format)
            self.texer.set_backend(self.backend)
            if self.index_style:
                self.texer.index.style = self.index_style
            self.texer.index.tool = self._params.get("latex.index.tool")
            self.texer.index.lang = self._params.get("latex.index.language")
            self.texer.compile(texfile)
            self.texer.print_misschars()
        except:
            # On error, dump the log errors and raise again
            self.texer.print_errors()
            raise

        if texout != binfile:
            shutil.move(texout, binfile)

    def clean(self):
        self.texer.clean()

    def reinit(self):
        self.texer.reinit()
 
