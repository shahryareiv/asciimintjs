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


def _indent(string, width=2):
    """Indent the <string> lines by <width> blank characters."""
    istr = ' ' * width
    s = istr + istr.join(string.splitlines(1))
    return s

class UnicodeInterval:
    """Unicode codepoint interval, including all codepoints between its minimum
    and maximum boundary.
    For any Unicode codepoint it can be queried if it belongs to the interval.
    """

    # Internal data attributes:
    # _min_boundary: Minimum boundary of the codepoint interval (ordinal)
    # _max_boundary: Maximum boundary of the codepoint interval (ordinal)

    _re_codepoint = re.compile(r'^[Uu]\+?([0-9A-Fa-f]+)$')

    def __init__(self):
        self._min_boundary = 0
        self._max_boundary = 0

    def __str__(self):
        """Dump the instance's data attributes."""
        string = '[' + str(self._min_boundary)
        if self._max_boundary != self._min_boundary:
            string += ',' + str(self._max_boundary)
        string += ']'
        return string

    def _unicode_to_ordinal(self, codepoint):
        """Return the ordinal of the specified codepoint."""
        m = self._re_codepoint.match(codepoint)
        if m:
            return int(m.group(1), 16)
        else:
            raise RuntimeError, 'Not a unicode codepoint: ' + codepoint

    def from_char(self, char):
        """Interval for a single character"""
        self._min_boundary = ord(char)
        self._max_boundary = self._min_boundary
        return self

    def from_codepoint(self, codepoint):
        """Interval for a single character defined as unicode string."""
        self._min_boundary = self._unicode_to_ordinal(codepoint)
        self._max_boundary = self._min_boundary
        return self

    def from_interval(self, codepoint1, codepoint2):
        """Interval from a unicode range."""
        self._min_boundary = self._unicode_to_ordinal(codepoint1)
        self._max_boundary = self._unicode_to_ordinal(codepoint2)
        if self._min_boundary > self._max_boundary:
            self._min_boundary, self._max_boundary = \
                self._max_boundary, self._min_boundary
        return self

    def contains(self, char):
        """
        Determine whether the specified character is contained in this
        instance's interval.
        """
        #print "%d in [%d - %d]?" % (ord(char), self._min_boundary,self._max_boundary)
        return (ord(char) >= self._min_boundary
                and ord(char) <= self._max_boundary)


class FontSpec:
    """
    Font specification, consisting of one or several unicode character
    intervals and of fonts to select for those characters. The object
    fully defines the fonts to switch to.
    """

    # Internal data attributes:
    # _intervals: UnicodeInterval list

    transition_types = ['enter', 'inter', 'exit']
    _re_interval = re.compile(r'^([Uu][0-9A-Fa-f]+)-([Uu][0-9A-Fa-f]+)$')
    _re_codepoint = re.compile(r'^([Uu][0-9A-Fa-f]+)$')

    def __init__(self, intervals=None, subfont_first=False):
        """Create a font specification from the specified codepoint intervals.
        The other data attributes will be set by the caller later.
        """
        self.type = ""
        self.id = None
        self.refmode = None
        self.transitions = {}
        self.fontspecs = [self]
        self.subfont_first = subfont_first
        self._ignored = []
        self.log = logging.getLogger("dblatex")

        for type in self.transition_types:
            self.transitions[type] = {}

        if not(intervals):
            self._intervals = []
            return

        try:
            self._intervals = list(intervals)
        except TypeError:
            self._intervals = [intervals]

    def fromnode(self, node):
        range = node.getAttribute('range')
        charset = node.getAttribute('charset')
        id = node.getAttribute('id')
        refmode = node.getAttribute('refmode')
        self.type = node.getAttribute('type')

        if (range):
            self._intervals = self._parse_range(range)
        elif (charset):
            for char in charset:
                self.add_char(char)

        # Unique identifier
        if (id):
            self.id = id
        if (refmode):
            self.refmode = refmode

        for transition_type in self.transition_types:
            self._parse_transitions(node, transition_type)

    def mainfont(self):
        # Try to return the most representative font of this spec
        return (self.transitions["enter"].get("main") or 
                self.transitions["enter"].get("sans"))

    def _parse_range(self, range):
        """Parse the specified /fonts/fontspec@range attribute to a
        UnicodeInterval list.
        """
        #print range
        intervals = []
        chunks = range.split()
        for chunk in chunks:
            m = self._re_interval.match(chunk)
            #print match
            if m:
                urange = UnicodeInterval().from_interval(m.group(1), m.group(2))
                intervals.append(urange)
            else:
                m = self._re_codepoint.match(chunk)
                if m:
                    intervals.append(
                        UnicodeInterval().from_codepoint(m.group(1)))
                else:
                    raise RuntimeError, 'Unable to parse range: "' + range + '"'
        return intervals

    def _parse_transitions(self, node, transition_type):
        """Evaluate the font elements of the specified fontspec element for the
        specified transition type (enter, inter or exit).
        """
        fontlist = self.transitions[transition_type]

        for dom_transition in node.getElementsByTagName(transition_type):
            for dom_font in dom_transition.getElementsByTagName('font'):
                font = ''
                types = dom_font.getAttribute("type")
                types = types.split()
                for dom_child in dom_font.childNodes:
                    if dom_child.nodeType == dom_child.TEXT_NODE:
                        font += dom_child.nodeValue
                if (font):
                    for type in types:
                        fontlist[type] = font

    def _switch_to(self, fonts):
        """
        Return a string with the XeTeX font switching commands for the
        specified font types.
        """
        s = ''
        for type, font in fonts.items():
            s += '\switch%sfont{%s}' % (type, font)
        if s:
            s = r"\savefamily" + s + r"\loadfamily{}"
        return s

    def enter(self):
        self.log.debug("enter in %s" % self.id)
        s = self._switch_to(self.transitions["enter"])
        return s

    def exit(self):
        self.log.debug("exit from %s" % self.id)
        s = self._switch_to(self.transitions["exit"])
        return s

    def interchar(self):
        s = self._switch_to(self.transitions["inter"])
        return s

    def __str__(self):
        """Dump the instance's data attributes."""
        string = 'FontSpec:'
        string += '\n  Id: %s' % self.id
        string += '\n  Refmode: %s' % self.refmode
        string += '\n  subFirst: %s' % self.subfont_first
        for interval in self._intervals:
            string += '\n' + _indent(str(interval))
        return string

    def add_subfont(self, fontspec):
        self.log.debug("%s -> %s" % (self.id, fontspec.id))
        if self.subfont_first:
            self.fontspecs.insert(-1, fontspec)
        else:
            self.fontspecs.append(fontspec)

    def add_char(self, char):
        self._intervals.append(UnicodeInterval().from_char(char))

    def add_uranges(self, ranges, depth=1):
        # Recursively extend the supported character range
        if depth:
            for f in self.fontspecs:
                if f != self:
                    f.add_uranges(ranges)
        self._intervals.extend(ranges)

    def add_ignored(self, ranges, depth=1):
        if depth:
            for f in self.fontspecs:
                if f != self:
                    f.add_ignored(ranges)
        self._ignored.extend(ranges)

    def get_uranges(self):
        return self._intervals

    def contains(self, char):
        #print "%s: %s" % (self.id, self._intervals)
        for interval in self._intervals:
            if interval.contains(char):
                return True
        else:
            return False

    def isignored(self, char):
        self.log.debug("%s: %s" % (self.id, [ str(a) for a in self._ignored ]))
        for interval in self._ignored:
            if interval.contains(char):
                return True
        else:
            return False

    def _loghas(self, id, char):
        try:
            self.log.debug("%s has '%s'" % (id, str(char)))
        except:
            self.log.debug("%s has '%s'" % (id, ord(char)))

    def match(self, char, excluded=None):
        """Determine whether the font specification matches the specified
        object, thereby considering refmode.
        """
        fontspec = None
        self.log.debug( "Lookup in %s" % self.id)
        if self.isignored(char):
            self._loghas(self.id, char)
            return self

        for fontspec in self.fontspecs:
            # Don't waste time in scanning excluded nodes
            if fontspec == excluded:
                continue
            #print " Look in %s" % fontspec.id
            if fontspec.contains(char):
                self._loghas(fontspec.id, char)
                return fontspec
        return None

