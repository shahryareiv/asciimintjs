#
# dblatex - Hyphenation classes to provide smart hyphenation of path like
# strings
#
import re

class Hyphenator:
    def __init__(self, codec=None):
        pass
    
    def hyphenate(self, text):
        return text


class BasicHyphenator(Hyphenator):
    """
    Hyphenates basically by putting an hyphenation point between each character.
    """
    def __init__(self, codec=None):
        self.codec = codec
        self.hyphenchar = "\-"

    def hyphenate(self, text):
        if self.codec: text = self.codec.decode(text)
        ntext = "\1".join(list(text))
        if self.codec: ntext = self.codec.encode(ntext)
        ntext = re.sub("\1? \1?", " ", ntext)
        ntext = ntext.replace("\1", self.hyphenchar)
        return ntext


class UrlHyphenator(Hyphenator):
    """
    Hyphenates <text> so that cutting is easier on URL separators.
    The hyphen chars are expected to be void to prevent from spurious
    characters in displayed filenames or URLs.

    The pathname words can be cut only after the <h_start> first characters
    and before the <h_stop> characters to avoid a cut just after one or two
    chars.

    Tip: the inter-chars can be defined with macros \HO and \HL, to be shorter
    like:

    \def\HL{\penalty9999} (h_char="\HL")
    \def\HO{\penalty5000} (h_sep="\HO")

    By default these shortcuts are not used to avoid some macro declaration in
    existing latex styles.
    """
    def __init__(self, codec=None,
                 h_sep="\penalty0 ", h_char="\penalty5000 ",
                 h_start=3, h_stop=3):
        self.codec = codec
        self.seps = r":/\@=?#;-."
        self.h_sep = h_sep
        self.h_char = h_char
        self.h_start = (h_start-1)
        self.h_stop = (h_stop-1)

    def _translate(self, text):
        if self.codec:
            return self.codec.encode(text)
        else:
            return text

    def hyphenate(self, text):
        if self.codec: text = self.codec.decode(text)

        vtext = []
        p = "([%s])" % re.escape(self.seps)
        words = re.split(p, text)
        for w in words:
            if not(w):
                continue
            if w in self.seps:
                vtext.append(self._translate(w) + self.h_sep)
            else:
                hword = w[self.h_start:-self.h_stop]
                if len(hword) < 2:
                    vtext.append(self._translate(w))
                else:
                    nw = w[:self.h_start]
                    nw += "\1".join(list(hword))
                    nw += w[-self.h_stop:]
                    nw = self._translate(nw)
                    nw = re.sub("\1? \1?", " ", nw)
                    nw = nw.replace("\1", self.h_char)
                    vtext.append(nw)

        ntext = "".join(vtext)
        return ntext


if __name__ == "__main__":
    url = "http://www.fg/foobar fun#fght/fkkkf.tz?id=123"
    h1 = BasicHyphenator()
    h2 = UrlHyphenator()
    print h1.hyphenate(url)
    print h2.hyphenate(url)
