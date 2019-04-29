import sys
import os
import codecs

from dbtexmf.dblatex.texcodec import LatexCodec
from fsencoder import FontSpecEncoder


class XetexCodec(LatexCodec):
    def __init__(self, fontconfig="", pre="", post=""):
        # Use the default TeX escapes, and encoding method
        LatexCodec.__init__(self, input_encoding="utf8",
                            output_encoding="utf8")

        # XeTeX font manager
        if not(fontconfig):
            fontconfig = os.getenv("DBLATEX_FONTSPEC_FILE", "xefont.xml")

        # If not proper fontconfig, fallback to default behaviour
        try:
            self._fontmgr = FontSpecEncoder(fontconfig)
        except:
            self._fontmgr = None
            return

        # Ignore the special characters \1 and \2 used as specific
        # substitution characters
        self._fontmgr.ignorechars("\1\2\r")

    def clear_errors(self):
        pass

    def get_errors(self):
        pass

    def decode(self, text):
        return self._decode(text)[0]

    def encode(self, text):
        # If no font manager, behaves as the default latex codec
        if not(self._fontmgr):
            return LatexCodec.encode(self, text)

        # Preliminary backslash substitution
        text = text.replace("\\", "\2")

        # Consider that each text sequence is in his own tex group
        self._fontmgr.reset()

        # Handle fonts for this Unicode string. We build a list of
        # strings, where each string is handled by a new font
        switchfonts = []
        for c in text:
            font, char = self._fontmgr.encode(c)
            # A new font, or empty switchfont list
            if font or not(switchfonts):
                sf = [font, char]
                switchfonts.append(sf)
            else:
            # No new font, so extend the current string
                sf[1] += char

        # Merge each part, after escaping each string
        text = ""
        for sf in switchfonts:
            sf[1] = self._texescape(sf[1])
            text += "".join(sf)

        # Encode for string output
        text = self._encode(text)[0]

        # Things are done, substitute the '\'
        text = text.replace("\2", r"\textbackslash{}")
        return "{" + text + "}"

