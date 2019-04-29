# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
LaTeX document building system for Rubber.

This module defines the class that parses the input LaTeX to load the expected
modules.
"""
import re

class TexParser:
    re_input = re.compile("\\\\input +(?P<arg>[^{} \n\\\\]+)")
    re_comment = re.compile(r"(?P<line>([^\\%]|\\%|\\)*)(%.*)?")

    def __init__(self, doc):
        self.doc = doc
        self.comment_mark = "%"
        self.exclude_mods = []
        self.hooks = {
            "usepackage"   : self.h_usepackage,
            "begin{btSect}": self.h_bibtopic,
        }
        self.update_rehooks()

    def update_rehooks(self):
        """
        Update the regular expression used to match macro calls using the keys
        in the `hook' dictionary. We don't match all control sequences for
        obvious efficiency reasons.
        """
        # Make a "foo|bar\*stub" list
        hooklist = [x.replace("*", "\\*") for x in self.hooks]

        pattern = "\\\\(?P<name>%s)\*?"\
                  " *(\\[(?P<opt>[^\\]]*)\\])?"\
                  " *({(?P<arg>[^{}]*)}|(?=[^A-Za-z]))"

        self.rehooks = re.compile(pattern % "|".join(hooklist))

    def add_hook(self, name, fun):
        """
        Register a given function to be called (with no arguments) when a
        given macro is found.
        """
        self.hooks[name] = fun
        self.update_rehooks()

    def parse(self, fd, exclude_mods=None):
        """
        Process a LaTeX source. The file must be open, it is read to the end
        calling the handlers for the macro calls. This recursively processes
        the included sources.

        If the optional argument 'dump' is not None, then it is considered as
        a stream on which all text not matched as a macro is written.
        """
        self.exclude_mods = exclude_mods or []
        self.lineno = 0
        for line in fd:
            self.parse_line(line)

    def parse_line(self, line, dump=None):
        self.lineno += 1

        # Remove comments
        line = self.re_comment.match(line).group("line")

        match = self.rehooks.search(line)
        while match:
            dict = match.groupdict()
            name = dict["name"]
            
            # The case of \input is handled specifically, because of the
            # TeX syntax with no braces

            if name == "input" and not dict["arg"]:
                match2 = self.re_input.search(line)
                if match2:
                    match = match2
                    dict = match.groupdict()

            if dump: dump.write(line[:match.start()])
            dict["match"] = line[match.start():match.end()]
            dict["line"] = line[match.end():]
            #dict["pos"] = { 'file': self.vars["file"], 'line': self.lineno }
            dict["pos"] = { 'file': "file", 'line': self.lineno }
            dict["dump"] = dump

#            if self.env.caching:
#                self.cache_list.append(("hook", name, dict))

            self.hooks[name](dict)
            line = dict["line"]
            match = self.rehooks.search(line)

        if dump: dump.write(line)

    def h_usepackage(self, dict):
        """
        Called when a \\usepackage macro is found. If there is a package in the
        directory of the source file, then it is treated as an include file
        unless there is a supporting module in the current directory,
        otherwise it is treated as a package.
        """
        if not dict["arg"]: return
        for name in dict["arg"].split(","):
            name = name.strip()
#            file = self.env.find_file(name + ".sty")
#            if file and not exists(name + ".py"):
#                self.process(file)
#            else:
            if (name in self.exclude_mods):
                continue
            self.doc.modules.register(name, dict)

    def h_bibtopic(self, dict):
        """
        Called when a \\btSect macro is found. It can also be loaded by a
        usepackage of bibtopic. Note that once loaded the btSect hook will be
        preempted by the bibtopic module hook.
        """
        if ("bibtopic" in self.exclude_mods):
            return
        self.doc.modules.register("bibtopic", dict)

