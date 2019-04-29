# 
# Slow interface to fontconfig for Dblatex, that only parses some commmand line
# output to store the fonts available on the system and their characteristics.
#
# An efficient solution should use some python bindings to directly call the
# C fontconfig library.
#
import logging
from subprocess import Popen, PIPE

def execute(cmd):
    p = Popen(cmd, stdout=PIPE)
    data = p.communicate()[0]
    rc = p.wait()
    if rc != 0:
        raise OSError("'%s' failed (%d)" % (" ".join(cmd), rc))
    return data


class FcFont:
    """
    Font Object with properties filled with the fc-match command output.
    """
    def __init__(self, fontnames, partial=False):
        self.log = logging.getLogger("dblatex")
        self.name = fontnames[0]
        self.aliases = fontnames[1:]
        self._completed = False
        if not(partial):
            self.complete()

    def complete(self):
        if not(self._completed):
            d = execute(["fc-match", "--verbose", self.name])
            d = d.strip()
            self._build_attr_from(d)
            self._completed = True

    def _build_attr_from(self, data):
        ninfos = self._splitinfos(data)

        # Remove the first line
        ninfos[0] = ninfos[0].split("\n")[1]
        for i in ninfos:
            if i: self._buildattr(i)
        
        # Check the consistency
        if self.family != self.name.replace("\-", "-"):
            raise ValueError("Unknown font '%s' vs '%s'" % (self.name,
            self.family))

    def _splitinfos(self, data):
        ninfos = [data]
        for sep in ("(s)", "(w)", "(=)"):
            infos = ninfos
            ninfos = []
            for i in infos:
                ni = i.split(sep)
                ninfos += ni
        return ninfos

    def _buildattr(self, infos):
        """
        Parse things like:
           'fullname: "Mukti"(s)
            fullnamelang: "en"(s)
            slant: 0(i)(s)
            weight: 80(i)(s)
            width: 100(i)(s)
            size: 12(f)(s)'
        """
        try:
            attrname, attrdata = infos.split(":", 1)
        except:
            # Skip this row
            self.log.warning("Wrong data? '%s'" % infos)
            return
        
        #print infos
        attrname = attrname.strip() # Remove \t
        attrdata = attrdata.strip() # Remove space

        # Specific case
        if attrname == "charset":
            self._build_charset(attrdata)
            return

        # Get the data type
        if (not(attrdata) or (attrdata[0] == '"' and attrdata[-1] == '"')):
            setattr(self, attrname, attrdata.strip('"'))
            return
        
        if (attrdata.endswith("(i)")):
            setattr(self, attrname, int(attrdata.strip("(i)")))
            return

        if (attrdata.endswith("(f)")):
            setattr(self, attrname, float(attrdata.strip("(f)")))
            return

        if (attrdata == "FcTrue"):
            setattr(self, attrname, True)
            return

        if (attrdata == "FcFalse"):
            setattr(self, attrname, False)
            return

    def _build_charset(self, charset):
        """
        Parse something like:
           '0000: 00000000 ffffffff ffffffff 7fffffff 00000000 00002001 00800000 00800000
            0009: 00000000 00000000 00000000 00000030 fff99fee f3c5fdff b080399f 07ffffcf
            0020: 30003000 00000000 00000010 00000000 00000000 00001000 00000000 00000000
            0025: 00000000 00000000 00000000 00000000 00000000 00000000 00001000 00000000'
        """
        self.charsetstr = charset
        self.charset = []
        lines = charset.split("\n")
        for l in lines:
            umajor, row = l.strip().split(":", 1)
            int32s = row.split()
            p = 0
            for w in int32s:
                #print "=> %s" % w
                v = int(w, 16)
                for i in range(0, 32):
                    m = 1 << i
                    #m = 0x80000000 >> i
                    if (m & v):
                        uchar = umajor + "%02X" % (p + i)
                        #print uchar
                        self.charset.append(int(uchar, 16))
                p += 32

    def remove_char(self, char):
        try:
            self.charset.remove(char)
        except:
            pass

    def has_char(self, char):
        #print self.family, char, self.charset
        return (ord(char) in self.charset)


class FcManager:
    """
    Collect all the fonts available in the system. The building can be partial,
    i.e. the font objects can be partially created, and updated later (when
    used).

    The class tries to build three ordered list of fonts, one per standard
    generic font family:
    - Serif      : main / body font
    - Sans-serif : used to render sans-serif forms
    - Monospace  : used to render verbatim / monospace characters
    """
    def __init__(self):
        self.log = logging.getLogger("dblatex")
        self.fonts = {}
        self.fonts_family = {}

    def get_font(self, fontname):
        font = self.fonts.get(fontname)
        if font:
            font.complete()
        return font

    def get_font_handling(self, char, all=False, family_type=""):
        if not(family_type):
            font_family = self.fonts.values()
        else:
            font_family = self.fonts_family.get(family_type, None)
        
        if not(font_family):
            return []

        fonts = self.get_font_handling_from(font_family, char, all=all)
        return fonts

    def get_font_handling_from(self, fontlist, char, all=False):
        fonts = []
        # Brutal method to get something...
        for f in fontlist:
            f.complete()
            if f.has_char(char):
                if all:
                    fonts.append(f)
                else:
                    return f
        return fonts

    def build_fonts(self, partial=False):
        self.build_fonts_all(partial=partial)
        self.build_fonts_family("serif")
        self.build_fonts_family("sans-serif")
        self.build_fonts_family("monospace")

    def build_fonts_all(self, partial=False):
        # Grab all the fonts installed on the system
        d = execute(["fc-list"])
        fonts = d.strip().split("\n")
        for f in fonts:
            fontnames = f.split(":")[0].split(",")
            mainname = fontnames[0]
            if not(mainname):
                continue
            if self.fonts.get(mainname):
                self.log.debug("'%s': duplicated" % mainname)
                continue

            #print fontnames
            font = FcFont(fontnames, partial=partial)
            self.fonts[mainname] = font

    def build_fonts_family(self, family_type):
        # Create a sorted list matching a generic family
        # Use --sort to have only fonts completing unicode range
        font_family = []
        self.fonts_family[family_type] = font_family
        d = execute(["fc-match", "--sort", family_type, "family"])
        fonts = d.strip().split("\n")
        for f in fonts:
            font = self.fonts.get(f)
            if not(font in font_family):
                font_family.append(font)
        #print family_type
        #print font_family

