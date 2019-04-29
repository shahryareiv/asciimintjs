#
# Basic wrapper for saxon.
#
import os
import logging
import re
from subprocess import call, Popen, PIPE

class Saxon:
    def __init__(self):
        self.catalogs = os.getenv("SGML_CATALOG_FILES")
        self.use_catalogs = 1
        self.log = logging.getLogger("dblatex")
        self.run_opts = []

    def get_deplist(self):
        return ["saxon"]

    def run(self, xslfile, xmlfile, outfile, opts=None, params=None):
        cmd = ["saxon-xslt", "-o", os.path.basename(outfile)] + self.run_opts
        if opts:
            cmd += opts
        cmd += [xmlfile, xslfile]
        if params:
            for param, value in params.items():
                cmd += ["%s=%s" % (param, "'%s'" % value)]
        self.system(cmd)

    def system(self, cmd):
        self.log.debug(" ".join(cmd))
        rc = call(cmd)
        if rc != 0:
            raise ValueError("saxon failed")

    def _has_xincludestyle(self):
        return False


class Xslt(Saxon):
    "Plugin Class to load"
