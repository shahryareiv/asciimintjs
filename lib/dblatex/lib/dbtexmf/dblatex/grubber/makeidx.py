# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
Indexing support with package 'makeidx'.

This module handles the processing of the document's index using makeindex.
It stores an MD5 sum of the .idx file between two runs, in order to detect
modifications.

The following directives are provided to specify options for makeindex:

  order <ordering> =
    Modify the ordering to be used. The argument must be a space separated
    list of:
    - standard = use default ordering (no options, this is the default)
    - german = use German ordering (option "-g")
    - letter = use letter instead of word ordering (option "-l")

  path <directory> =
    Add the specified directory to the search path for styles.

  style <name> =
    Use the specified style file.
"""
import sys

from index import Index

class Module (Index):
    def __init__ (self, doc, dict):
        """
        Initialize the module, checking if there is already an index.
        """
        Index.__init__(self, doc, "idx", "ind", "ilg")
