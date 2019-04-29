#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Time-stamp: <2008-06-23 22:21:26 ah>

"""
Provide an encoder for a font specification configuration: the encoder is fed
with Unicode characters one by one and determines the needed font switches
between the preceding and the current character.
"""

import re
import xml.dom.minidom
import logging

from fcfallback import FcFallbackFontSpec, DefaultFontSpec
from fontspec import FontSpec, _indent


class FontSpecConfig:
    """
    This object parses an XML fontspec configuration file and build the
    resulting fontspec tree, the root fontspec being the default font
    to apply.
    
    The fontspec configuration file defines the fonts to apply in order
    of precedence (and for some Unicode ranges) and the font levels (or
    subfonts) thanks to the 'refmode' attribute that links a font to its
    parent.
    """

    def __init__(self, conf_file):
        """Create a font specification configuration from the specified file
        (file name or file-like object).
        """
        self.log = logging.getLogger("dblatex")
        self.fontspecs = []
        self.fontnames = {}

        dom_document = xml.dom.minidom.parse(conf_file)
        for dom_fontspec in dom_document.getElementsByTagName('fontspec'):
            default = dom_fontspec.getAttribute('default')
            if default:
                self.log.debug("has default")
                fallback = dom_fontspec.getAttribute('fallback')
                if fallback == "fontconfig":
                    self.default_fontspec = FcFallbackFontSpec()
                else:
                    self.default_fontspec = DefaultFontSpec()
                fontspec = self.default_fontspec
            else:
                fontspec = FontSpec()

            fontspec.fromnode(dom_fontspec)

            if fontspec != self.default_fontspec:
                self.fontspecs.append(fontspec)
            if fontspec.id:
                self.fontnames[fontspec.id] = fontspec

        dom_document.unlink()

        if not(self.default_fontspec):
            self.default_fontspec = DefaultFontSpec()

        self.build_tree()

    def build_tree(self):
        """
        Build the fontspec tree, the root node being the default font
        to apply. The fontspecs without a refmode (i.e. not being
        explicitely a subfont) are direct children of the default font.
        """
        to_ignore = []
        for fontspec in self.fontspecs:
            if fontspec.type == "ignore":
                to_ignore.append(fontspec)
                continue

            if not(fontspec.refmode):
                f = self.default_fontspec
            else:
                f = self.fontnames.get(fontspec.refmode, None)

            if (f):
                f.add_subfont(fontspec)
            else:
                raise ValueError("wrong fontspec tree")

        # Insert the characters to ignore in fontspecs
        for f in to_ignore:
            self.default_fontspec.add_ignored(f.get_uranges())

    def __str__(self):
        """Dump the instance's data attributes."""
        string = 'FontSpecConfig:'
        string += '\n  Fontspec list:'
        for fontspec in self.fontspecs:
            string += '\n' + _indent(str(fontspec), 4)
        return string

