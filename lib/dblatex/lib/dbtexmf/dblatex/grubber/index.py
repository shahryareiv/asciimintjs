# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2004--2006
"""
Indexing support with package 'index'.

This module handles the processing of the document's indices using a tool like
makeindex or xindy. It stores an MD5 sum of the source (.idx) file between two
runs, in order to detect modifications.

The following directives are provided to specify options for makeindex:

  tool <tool> =
    Choose which indexing tool should be used. Currently this can be either
    "makeindex" (by default) or "xindy".

  language <lang> =
    Choose the language used for sorting the index (xindy only).

  modules <mod> <mod> ... =
      Specify which modules xindy should use for the index.

  order <ordering> =
    Modify the ordering to be used (makeindex only, supported by xindy with
    warnings). The argument must be a space separated list of:
    - standard = use default ordering (no options, this is the default)
    - german = use German ordering (option "-g")
    - letter = use letter instead of word ordering (option "-l")

  path <directory> =
    Add the specified directory to the search path for styles.

  style <name> =
    Use the specified style file.

They all accept an optional argument first, enclosed in parentheses as in
"index.path (foo,bar) here/", to specify which index they apply to. Without
this argument, they apply to all indices declared at the point where they
occur.
"""

import os
from os.path import *
import re, string
import subprocess
import xml.dom.minidom

from subprocess import Popen, PIPE
from msg import _, msg
from plugins import TexModule
from util import md5_file


class Xindy:
    """
    Xindy command wrapper
    """
    def __init__(self, doc, idxfile, target, transcript="",
                 opts=None, modules=None,
                 index_lang="", style=""):
        self.doc = doc
        self.idxfile = idxfile
        self.target = target
        self.transcript = transcript
        self.opts = opts or []
        self.modules = modules or []
        self.index_lang = index_lang
        self.path_var = "XINDY_SEARCHPATH"
        mapfile = os.path.join(os.path.dirname(__file__), "xindylang.xml")
        self.languages = self.map_languages(mapfile)
        self._re_hyperindex = re.compile(r"hyperindexformat{\\(.*?)}}{",
                                         re.M|re.DOTALL)
        self.invalid_index_ranges = []

    def map_languages(self, mapfile):
        languages = {}
        dom_document = xml.dom.minidom.parse(mapfile)
        for dom_fontspec in dom_document.getElementsByTagName('map'):
            lang = dom_fontspec.getAttribute('lang')
            xindylang = dom_fontspec.getAttribute('xindylang')
            if xindylang:
                languages[lang] = xindylang
        dom_document.unlink()
        return languages

    def command(self):
        cmd = []
        if self.doc.program == "xelatex":
            # If raw index is in UTF-8 the texindy command cannot be used
            cmd.extend(["xindy", "-M", "texindy", "-C", self.doc.encoding])
            # To behave even more like texindy
            cmd.extend(["-q", "-M", "page-ranges"])
        else:
            # Call texindy to handle LICR encoded raw index
            # Equivalent to xindy arguments (beware of module order):
            #   "xindy", "-M", "tex/inputenc/latin",
            #            "-M", "texindy", "-C", "latin",
            #            "-I", "latex"
            cmd.extend(["texindy"])

        # Specific output files?
        if self.target:
            cmd.extend(["-o", self.target])
        if self.transcript:
            cmd.extend(["-t", self.transcript])

        # Find out which language to use
        if self.index_lang:
            lang = self.index_lang
        elif self.doc.lang:
            lang = self.languages.get(self.doc.lang)
            if not(lang):
                msg.warn(_("xindy: lang '%s' not found" % \
                           self.doc.lang), pkg="index")
            else:
                msg.log(_("xindy: lang '%s' mapped to '%s'" % \
                           (self.doc.lang, lang)), pkg="index")
        else:
            lang = None

        if lang:
            cmd.extend(["-L", lang])

        for mod in self.modules:
            cmd.extend(["-M", mod])

        if self.opts:
            cmd.extend(self.opts)

        cmd.append(self.idxfile)
        return cmd

    def _find_index_encoding(self, logname):
        # Texindy produces latin-* indexes. Try to find out which one from
        # the modules loaded by the script (language dependent)
        re_lang = re.compile("loading module \"lang/.*/(latin[^.-]*)")
        logfile = open(logname)
        encoding = ""
        for line in logfile:
            m = re_lang.search(line)
            if m:
                encoding = m.group(1)
                break

        logfile.close()
        return encoding

    def _index_is_unicode(self):
        f = file(self.target, "r")
        is_unicode = True 
        for line in f:
            try:
                line.decode("utf8")
            except:
                is_unicode = False
                break
        f.close()
        return is_unicode

    def _sanitize_idxfile(self):
        #
        # Remove the 'hyperindexformat' of the new hyperref that makes a mess
        # with Xindy. If not, the following error is raised by Xindy:
        # "WARNING: unknown cross-reference-class `hyperindexformat'! (ignored)"
        #
        f = file(self.idxfile, "r")
        data = f.read()
        f.close()
        data, nsub = self._re_hyperindex.subn(r"\1}{", data)
        if not(nsub):
            return
        msg.debug("Remove %d unsupported 'hyperindexformat' calls" % nsub)
        f = file(self.idxfile, "w")
        f.write(data)
        f.close()

    def _fix_invalid_ranges(self):
        if not(self.invalid_index_ranges): return
        f = open(self.idxfile)
        lines = f.readlines()
        f.close()

        # Track the lines with the wrong index ranges
        for i, line in enumerate(lines):
            for entry in self.invalid_index_ranges:
                if entry.index_key in line:
                    entry.add_line(i, line)

        # Summary of the lines to remove in order to fix the ranges
        skip_lines = []
        for entry in self.invalid_index_ranges:
            skip_lines.extend(entry.skip_lines)
            entry.reinit()
        if not(skip_lines): return
        
        # Remove the lines starting from the end to always have valid line num
        msg.debug("xindy: lines to remove from %s to fix ranges: %s" %\
                  (self.idxfile, skip_lines))
        skip_lines.sort()
        skip_lines.reverse()
        for line_num in skip_lines:
            del lines[line_num]
        f = open(self.idxfile, "w")
        f.writelines(lines)
        f.close()

    def _detect_invalid_ranges(self, data):
        # Look for warnings like this:
        #
        # WARNING: Found a :close-range in the index that wasn't opened before!
        #          Location-reference is 76 in keyword (Statute of Anne (1710))
        #          I'll continue and ignore this.
        #
        # Do it only once on the first run to find wrong indexes.
        if (self.invalid_index_ranges): return
        blocks = re.split("(WARNING:|ERROR:)", data, re.M)
        check_next_block = False
        for block in blocks:
            if "WARNING" in block:
                check_next_block = True
            elif check_next_block:
                m = re.search("Found.*?-range .*"\
                              "Location-reference is \d+ in keyword \((.*)\)",
                              block, re.M|re.DOTALL)
                if m: self.invalid_index_ranges.append(Indexentry(m.group(1)))
                check_next_block = False

    def run(self):
        self._sanitize_idxfile()
        self._fix_invalid_ranges()
        cmd = self.command()
        msg.debug(" ".join(cmd))

        # Collect the script output, and errors
        logname = join(dirname(self.target), "xindy.log")
        logfile = open(logname, "w")
        p = Popen(cmd, stdout=logfile, stderr=PIPE)
        errdata = p.communicate()[1]
        rc = p.wait()
        if msg.stdout:
            msg.stdout.write(errdata)
        else:
            msg.warn(_(errdata.strip()))
        logfile.close()
        if (rc != 0):
            msg.error(_("could not make index %s") % self.target)
            return 1

        self._detect_invalid_ranges(errdata)

        # Now convert the built index to UTF-8 if required
        if cmd[0] == "texindy" and self.doc.encoding == "utf8":
            if not(self._index_is_unicode()):
                encoding = self._find_index_encoding(logname)
                tmpindex = join(dirname(self.target), "new.ind")
                cmd = ["iconv", "-f", encoding, "-t", "utf8",
                       "-o", tmpindex, self.target]
                msg.debug(" ".join(cmd))
                rc = subprocess.call(cmd)
                if rc == 0: os.rename(tmpindex, self.target)

        return rc

class Indexentry:
    """
    Index entry wrapper from idxfile. Its role is to detect range anomalies
    """
    _re_entry = re.compile("\indexentry{(.*)\|([\(\)]?).*}{(\d+)}", re.DOTALL)

    def __init__(self, index_key):
        self.index_key = index_key
        self.skip_lines = []
        self.last_range_page = 0
        self.last_range_line = -1
        self.last_range_open = False

    def reinit(self):
        self.__init__(self.index_key)

    def add_line(self, line_num, indexentry):
        m = self._re_entry.search(indexentry)
        if not(m):
            return
        index_key = m.group(1).split("!")[-1]
        if index_key != self.index_key:
            return
        range_state = m.group(2)
        page = int(m.group(3))

        #print "Found %s at %d" % (index_key, page)
        if range_state == "(":
            # If a starting range overlap the previous range remove
            # this intermediate useless range close/open
            if page <= self.last_range_page:
                self.skip_lines += [self.last_range_line, line_num]
            self.last_range_page = page
            self.last_range_line = line_num
            self.last_range_open = True
        elif range_state == ")":
            self.last_range_page = page
            self.last_range_line = line_num
            self.last_range_open = False
        elif range_state == "":
            # If a single indexentry is within a range, skip it
            if self.last_range_open == True:
                self.skip_lines += [line_num]
        

class Makeindex:
    """
    Makeindex command wrapper
    """
    def __init__(self, doc, idxfile, target, transcript="",
                 opts=None, modules=None,
                 index_lang="", style=""):
        self.doc = doc
        self.idxfile = idxfile
        self.target = target
        self.transcript = transcript
        self.opts = opts or []
        self.path_var = "INDEXSTYLE"
        self.style = style

    def command(self):
        cmd = ["makeindex", "-o", self.target] + self.opts
        if self.transcript:
            cmd.extend(["-t", self.transcript])
        if self.style:
            cmd.extend(["-s", self.style])
        cmd.append(self.idxfile)
        return cmd

    def _index_is_unicode(self):
        f = file(self.target, "r")
        is_unicode = True 
        for line in f:
            try:
                line.decode("utf8")
            except:
                is_unicode = False
                break
        f.close()
        return is_unicode

    def run(self):
        cmd = self.command()
        msg.debug(" ".join(cmd))

        # Makeindex outputs everything to stderr, even progress messages
        rc = subprocess.call(cmd, stderr=msg.stdout)
        if (rc != 0):
            msg.error(_("could not make index %s") % self.target)
            return 1

        # Beware with UTF-8 encoding, makeindex with headings can be messy
        # because it puts in the headings the first 8bits char of the words
        # under the heading which can be an invalid character in UTF-8
        if (self.style and self.doc.encoding == "utf8"):
            if not(self._index_is_unicode()):
                # Retry without style to avoid headings
                msg.warn(_("makeindex on UTF8 failed. Retry..."))
                self.style = ""
                return self.run()

        return rc


class Index(TexModule):
    """
    This class represents a single index.
    """
    def __init__ (self, doc, source, target, transcript):
        """
        Initialize the index, by specifying the source file (generated by
        LaTeX), the target file (the output of makeindex) and the transcript
        (e.g. .ilg) file.  Transcript is used by glosstex.py.
        """
        self.paranoid = True
        self.doc = doc
        self.pbase = doc.src_base
        self.source = doc.src_base + "." + source
        self.target = doc.src_base + "." + target
        self.transcript = doc.src_base + "." + transcript

        # In paranoid mode, can output only in current working dir
        if self.paranoid and (os.path.dirname(self.target) == os.getcwd()):
            self.target = os.path.basename(self.target)
            self.transcript = os.path.basename(self.transcript)

        if os.path.exists(self.source):
            self.md5 = md5_file(self.source)
        else:
            self.md5 = None

        self.tool = "makeindex"
        self.tool_obj = None
        self.lang = None   # only for xindy
        self.modules = []  # only for xindy
        self.opts = []
        self.path = []
        self.style = None  # only for makeindex


    def do_language (self, lang):
        self.lang = lang

    def do_modules (self, *args):
        self.modules.extend(args)

    def do_order (self, *args):
        for opt in args:
            if opt == "standard": self.opts = []
            elif opt == "german": self.opts.append("-g")
            elif opt == "letter": self.opts.append("-l")
            else: msg.warn(
                _("unknown option '%s' for 'makeidx.order'") % opt)

    def do_path (self, path):
        self.path.append(self.doc.abspath(path))

    def do_style (self, style):
        self.style = style

    def do_tool (self, tool):
        if tool not in ("makeindex", "xindy"):
            msg.error(_("unknown indexing tool '%s'") % tool)
        self.tool = tool


    def post_compile (self):
        """
        Run the indexer tool
        """
        if not os.path.exists(self.source):
            msg.log(_("strange, there is no %s") % self.source, pkg="index")
            return 0
        if not self.run_needed():
            return 0

        msg.progress(_("processing index %s") % self.source)

        if not(self.tool_obj):
            if self.tool == "makeindex":
                index_cls = Makeindex
            elif self.tool == "xindy":
                index_cls = Xindy

            self.tool_obj = index_cls(self.doc,
                              self.source,
                              self.target,
                              transcript=self.transcript,
                              opts=self.opts,
                              modules=self.modules,
                              index_lang=self.lang,
                              style=self.style)

        rc = self.tool_obj.run()
        if rc != 0:
            return rc

        self.doc.must_compile = 1
        return 0

    def run_needed (self):
        """
        Check if makeindex has to be run. This is the case either if the
        target file does not exist or if the source file has changed.
        """
        if os.path.getsize(self.source) == 0:
            msg.log(_("the index file %s is empty") % self.source, pkg="index")
            return 0
        new = md5_file(self.source)
        if not os.path.exists(self.target):
            self.md5 = new
            return 1
        if not self.md5:
            self.md5 = new
            msg.log(_("the index file %s is new") % self.source, pkg="index")
            return 1
        if self.md5 == new:
            msg.log(_("the index %s did not change") % self.source, pkg="index")
            return 0
        self.md5 = new
        msg.log(_("the index %s has changed") % self.source, pkg="index")
        return 1

    def clean (self):
        """
        Remove all generated files related to the index.
        """
        for file in self.source, self.target, self.transcript:
            if exists(file):
                msg.log(_("removing %s") % file, pkg="index")
                os.unlink(file)

re_newindex = re.compile(" *{(?P<idx>[^{}]*)} *{(?P<ind>[^{}]*)}")
re_optarg = re.compile("\((?P<list>[^()]*)\) *")

class Module (TexModule):
    def __init__ (self, doc, dict):
        """
        Initialize the module with no index.
        """
        self.doc = doc
        self.indices = {}
        self.defaults = []
        self.commands = {}
        doc.parser.add_hook("makeindex", self.makeindex)
        doc.parser.add_hook("newindex", self.newindex)

    def register (self, name, idx, ind, ilg):
        """
        Register a new index.
        """
        index = self.indices[name] = Index(self.doc, idx, ind, ilg)
        for cmd in self.defaults:
            index.command(*cmd)
        if self.commands.has_key(name):
            for cmd in self.commands[name]:
                index.command(*cmd)

    def makeindex (self, dict):
        """
        Register the standard index.
        """
        self.register("default", "idx", "ind", "ilg")

    def newindex (self, dict):
        """
        Register a new index.
        """
        m = re_newindex.match(dict["line"])
        if not m:
            return
        index = dict["arg"]
        d = m.groupdict()
        self.register(index, d["idx"], d["ind"], "ilg")
        msg.log(_("index %s registered") % index, pkg="index")

    def command (self, cmd, args):
        indices = self.indices
        names = None
        if len(args) > 0:
            m = re_optarg.match(args[0])
            if m:
                names = m.group("list").split(",")
                args = args[1:]
        if names is None:
            self.defaults.append([cmd, args])
            names = indices.keys()
        for index in names:
            if indices.has_key(index):
                indices[index].command(cmd, args[1:])
            elif self.commands.has_key(index):
                self.commands[index].append([cmd, args])
            else:
                self.commands[index] = [[cmd, args]]

    def post_compile (self):
        for index in self.indices.values():
            if index.post_compile():
                return 1
        return 0

    def clean (self):
        for index in self.indices.values():
            index.clean()
        return 0

