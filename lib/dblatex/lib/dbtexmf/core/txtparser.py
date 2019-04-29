#
# DbTex configuration parser. Maybe we could use or extend ConfigParser.
#
import os
import re

#
# Functions used by the config parsers and by the dbtex command parser
#
def texinputs_parse(strpath, basedir=None):
    """
    Transform the TEXINPUTS string to absolute normalized paths,
    but keep intact the '//' suffix if any. The absolute paths are
    computed from current one or from <basedir> when specified.
    """
    paths = []
    for p in strpath.split(os.pathsep):
        if not(os.path.isabs(p)):
            if not(basedir):
                d = os.path.realpath(p)
            else:
                d = os.path.normpath(os.path.join(basedir, p))
        else:
            d = os.path.normpath(p)
        if p.endswith("//"):
            d += "//"
        paths.append(d)
    return paths

def texstyle_parse(texstyle):
    sty = os.path.basename(texstyle)
    dir = os.path.dirname(texstyle)
    if sty.endswith(".sty"):
        path = os.path.realpath(dir)
        sty = sty[:-4]
        if not(os.path.isfile(texstyle)):
            raise ValueError("Latex style '%s' not found" % texstyle)
    elif (dir):
        raise ValueError("Invalid latex style path: missing .sty")
    else:
        path = ""
    return ("latex.style=%s" % sty, path)



class OptMap:
    def __init__(self, option):
        self.option = option

    def format(self, dir, value):
        return ["%s=%s" % (self.option, value)]

class PathMap(OptMap):
    def format(self, dir, value):
        if not(os.path.isabs(value)):
            value = os.path.normpath(os.path.join(dir, value))
        return OptMap.format(self, dir, value)

class TexMap(OptMap):
    def format(self, dir, value):
        paths = texinputs_parse(value, basedir=dir)
        return OptMap.format(self, dir, ":".join(paths))

class NoneMap(OptMap):
    def format(self, dir, value):
        return value.split()


class TextConfig:
    conf_mapping = {
        'TexInputs' : TexMap('--texinputs'),
        #'PdfInputs' : OptMap('--pdfinputs'),
        'TexPost'   : PathMap('--texpost'),
        'FigPath'   : PathMap('--fig-path'),
        'XslParam'  : PathMap('--xsl-user'),
        'TexStyle'  : OptMap('--texstyle'),
        'Options'   : NoneMap('')
    }

    def __init__(self):
        self._options = []
        self.reparam = re.compile("^\s*([^:=\s]+)\s*:\s*(.*)")

    def options(self):
        return self._options

    def fromfile(self, file):
        dir = os.path.dirname(os.path.realpath(file))
        f = open(file)

        for line in f:
            # Remove the comment
            line = line.split("#")[0]
            m = self.reparam.match(line)
            if not(m):
                continue
            key = m.group(1)
            value = m.group(2).strip()
            if not self.conf_mapping.has_key(key):
                continue
            o = self.conf_mapping[key]

            # The paths can be relative to the config file
            self._options += o.format(dir, value)

        f.close()

