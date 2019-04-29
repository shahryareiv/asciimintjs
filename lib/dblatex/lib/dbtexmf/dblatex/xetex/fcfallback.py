from fontspec import FontSpec
from fcmanager import FcManager


class DefaultFontSpec(FontSpec):
    """
    The default fontspec gives priority to its children, and 
    contains any character.
    """
    def __init__(self):
        FontSpec.__init__(self, subfont_first=True)
    
    def contains(self, char):
        return True


class FcFallbackFontSpec(DefaultFontSpec):
    """
    Default fontspec that finds fonts from fontconfig 
    if the preexisting fontspecs don't match.

    Currently this class is the only interface between the
    two worlds (fontspec and fontconfig).
    """
    def __init__(self):
        DefaultFontSpec.__init__(self)
        self.fcmanager = FcManager()
        self.fccache = {}
        self.fcmissed = []
        try:
            self.fcmanager.build_fonts(partial=True)
        except:
            self.fcmanager = None
    
    def _loghas(self, id, char):
        pass 

    def _loghas2(self, id, char):
        DefaultFontSpec._loghas(self, id, char)

    def match(self, char, excluded=None):
        fontspec = DefaultFontSpec.match(self, char, excluded)
        if fontspec != self or not(self.fcmanager):
            self._loghas2(fontspec.id, char)
            return fontspec

        if self.isignored(char):
            self._loghas2(self.id, char)
            return self

        # Scan again the predefined fontspecs and check with fontconfig
        # if their charset can be extended

        for fontspec in self.fontspecs:

            if fontspec in self.fcmissed:
                print "Specified font '%s' is missing in the system!" % \
                      (fontspec.mainfont())
                continue

            fcfont = self.fccache.get(fontspec.mainfont()) or \
                     self.fcmanager.get_font(fontspec.mainfont())

            if not(fcfont):
                self.fcmissed.append(fontspec)
                continue

            if fcfont.has_char(char):
                fontspec.add_char(char)
                self._loghas2(fontspec.id + "[fc]", char)
                return fontspec

        # Find the first fcfont that has this char in its charset
        fcfonts = {}
        for font_type in ("serif", "sans-serif", "monospace"):
            fcfonts[font_type] = self.fcmanager.get_font_handling(char,
                                                         family_type=font_type)
        # FIXME: attribuer les autres fonts si font nexiste pas dans le type
        if not(fcfont):
            self._loghas2(self.id + "[?fc]", char)
            return self

        # Extend the fontspec group
        fontspec = self.spawn_fontspec_from_fcfonts(fcfonts, char)
        self._loghas2(fontspec.id + "[A fc]", char)
        return fontspec

    def spawn_fontspec_from_fcfonts(self, fcfonts, char):
        self.log.info("New fontspec '%s' matching U%X from fontconfig"\
              % (fcfonts["serif"].family, ord(char)))
        # Create a new font
        fontspec = FontSpec()
        fontspec.id = fcfont.family
        fontspec.transitions["enter"]["main"] = fcfonts["serif"].family
        fontspec.transitions["enter"]["sans"] = fcfonts["sans-serif"].family
        fontspec.transitions["enter"]["mono"] = fcfonts["monospace"].family
        fontspec.add_char(char)
        fontspec.add_ignored(self._ignored)
        # Register the font and its related fontconfig object
        for fcfont in fcfonts.values():
            self.fccache[fcfont.name] = fcfont
        self.add_subfont(fontspec)
        return fontspec

