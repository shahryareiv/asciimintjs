#
# Basic wrapper for xsltproc. Maybe we should directly use the lixslt Python
# API.
#
import os
import logging
import re
from subprocess import call, Popen, PIPE

class XsltProc:
    def __init__(self):
        self.catalogs = os.getenv("SGML_CATALOG_FILES")
        self.use_catalogs = 1
        self.log = logging.getLogger("dblatex")
        self.run_opts = ["--xinclude"]
        # If --xincludestyle is supported we *must* use it to support external
        # listings (see mklistings.xsl and pals)
        if self._has_xincludestyle():
            self.run_opts.append("--xincludestyle")

    def get_deplist(self):
        return ["xsltproc"]

    def run(self, xslfile, xmlfile, outfile, opts=None, params=None):
        cmd = ["xsltproc", "-o", os.path.basename(outfile)] + self.run_opts
        if self.use_catalogs and self.catalogs:
            cmd.append("--catalogs")
        if params:
            for param, value in params.items():
                cmd += ["--param", param, "'%s'" % value]
        if opts:
            cmd += opts
        cmd += [xslfile, xmlfile]
        self.system(cmd)

    def system(self, cmd):
        self.log.debug(" ".join(cmd))
        rc = call(cmd)
        if rc != 0:
            raise ValueError("xsltproc failed")

    def _has_xincludestyle(self):
        # check that with help output the option is there
        p = Popen(["xsltproc"], stdout=PIPE)
        data = p.communicate()[0]
        m = re.search("--xincludestyle", data, re.M)
        if not(m):
            return False
        else:
            return True


class Xslt(XsltProc):
    "Plugin Class to load"
