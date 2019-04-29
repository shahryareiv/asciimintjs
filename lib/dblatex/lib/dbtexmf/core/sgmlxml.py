#
# Basic class handling osx() call. It tries to replace the entities by
# the equivalent unicode characters.
#
import os
import sys
import re
import logging
from subprocess import call

class Osx:
    def __init__(self):
        self.opts = ["-xlower",
                     "-xno-nl-in-tag",
                     "-xempty",
                     "-xno-expand-internal",
                     "-xid"] # To have id() working without a DTD
        self.log = logging.getLogger("dblatex")

    def replace_entities(self, entfile, mapfile, outfile=None):
        # Find out the SDATA entities to replace
        re_ent = re.compile('<!ENTITY +([^\s]+) +"?\[([^\s"]+) *\]"?>')
        f = open(entfile)
        lines = f.readlines()
        f.close()

        # Trivial case where no entities to map
        if not(lines):
            return

        ents = []
        for line in lines:
            ents += re_ent.findall(line)
        self.log.debug("Entities to map: %s" % ents)

        # Now, get their Unicode mapping
        entpat = "^(%s)\s+[^\s]+\s+0(x[^\s]+)" % "|".join([x for x, y in ents])
        re_map = re.compile(entpat)
        entmap = []
        f = open(mapfile)
        for line in f:
            entmap += re_map.findall(line.split("#")[0])
        f.close()
        self.log.debug("Entity map: %s" % entmap)

        # Replace the entity definitions by their Unicode equivalent
        entdict = {}
        for ent, uval in entmap:
            entdict[ent] = \
                (re.compile('<!ENTITY\s+%s\s+"?\[[^\]]+\]"?\s*>' % ent),
                            '<!ENTITY %s "&#%s;">' % (ent, uval))

        nlines = []
        for line in lines:
            mapped = []
            for ent in entdict:
                reg, rep = entdict[ent]
                line, n = reg.subn(rep, line)
                if n:
                    mapped.append(ent)
            nlines.append(line)
            for ent in mapped:
                del entdict[ent]

        if not(outfile): outfile = entfile
        f = open(outfile, "w")
        f.writelines(nlines)
        f.close()

    def run(self, sgmlfile, xmlfile):
        errfile = "errors.osx"
        f = open(xmlfile, "w")
        rc = call(["osx"] + self.opts + ["-f", errfile, sgmlfile], stdout=f)
        f.close()
        if rc != 0:
            i = 0
            f = open(errfile)
            for line in f:
                sys.stderr.write(line)
                i += 1
                if i == 10: break
            f.close()
            raise OSError("osx failed")

        # Now, replace the SDATA entities
        sgmlmap = os.path.join(os.path.dirname(__file__), "sgmlent.txt")
        self.replace_entities("intEntities.dtf", sgmlmap)

